//
//  MainVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/2/23.
//

import UIKit
import MyLibrary
import CoreLocation

class MainVC:UIViewController,ViewSpecificController {
    
    // MARK: - RootView
    typealias RootView = MainRootView
    weak var coordinator: MainCoordinator?
    private var regions = [Regions]()
    private var dataManager = DataManager.shared
    
    private var longitute = String()
    private var latitute = String()
    private var tempToday = String()
    private var tempTomorrow = String()
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
        // MARK: - Lifecycle
    override func loadView() {
        let rootView = MainRootView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "bgMain")
        self.appearanceSettings()
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        guard let cell = self.view().tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? MainTimeCell else {return}
        cell.spb.animateToIndex(index: Configs().getProgressAnimatedIndex())
    }
    
    private func appearanceSettings() {
        self.view().aboutOnClick = {
            self.coordinator?.pushAbout()
        }
        self.view().ixResponder = self
        UIApplication.shared.isIdleTimerDisabled = true
        CheckUpdate.shared.showUpdate(withConfirmation: true)
        
        self.getCities()
        self.getNamazTimes()
        self.getMediaFiles()
    }
    
    
    func mainItemsDidSelect(type: MainPageItemType) {
        switch type {
        case .quran:
            self.coordinator?.pushToBribes()
        case .quranStudy:
            self.coordinator?.pushToStydy()
        case .payerOrder:
            self.coordinator?.pushToPrayerRule()
        case .qibla:
            self.coordinator?.pushToQibla()
        case .prayerTime:
            self.coordinator?.pushToPrayerTime()
        case .rosary:
            self.coordinator?.pushToRosary()
        }
    }
}


// Get whole month namaz times
extension MainVC {
    func getNamazTimes() {
        let currentLocation = locationManager.location
        let long:String = String(currentLocation?.coordinate.longitude ?? 69.2773884)
        let lati:String = String(currentLocation?.coordinate.latitude ?? 41.3188992)
        self.getAllMonthTimes(long: long, lati: lati)
    }

    func getAllMonthTimes(long:String, lati:String) {
        let today = MainBean.shared.getTodayDate()
        let namazInfos = dataManager.fetchNamazDayInfo(day: today)
        
        if !namazInfos.isEmpty {
            if let info = namazInfos.first {
                self.setRealNamazTime(info: info)
            }
        } else {
            // Get period dates for the month
            let startDate = MainBean.shared.getFirstDayOfMonth().replacingOccurrences(of: ".", with: "-")
            let endDate = MainBean.shared.getLastDayOfMonth().replacingOccurrences(of: ".", with: "-")
            
            self.getWholeMonthTimes(long: long, lati: lati, startDate: startDate, endDate: endDate) { monthlyNamazInfos in
                // Save all month data to Core Data
                self.dataManager.insertNamazInfo(namazInfos: monthlyNamazInfos)
                
                // Set today's namaz time
                if let todayInfo = monthlyNamazInfos.first(where: { $0.day == today }) {
                    self.setRealNamazTime(info: todayInfo)
                }
            }
        }
    }
    
    func getWholeMonthTimes(long:String, lati:String, startDate:String, endDate:String, onComplete: @escaping(([NamazTimeInfos])->())){
        let timeZone = MainBean.shared.getTimeZone()
        
        let request = NamazPeriodRequest(
            startDate: startDate,
            endDate: endDate,
            lan: long,
            lat: lati,
            timezone: timeZone
        )
        
        self.getTimePeriods(data: request) { response in
            var namazInfos = [NamazTimeInfos]()
            
            // Process the period response and convert to NamazTimeInfos
            let prayerTimes = response.data
            for (index, dayData) in prayerTimes.enumerated() {
                // Get next day's fajr time (bomdod)
                let nextDayBomdod = index + 1 < prayerTimes.count ? 
                    prayerTimes[index + 1].timings.fajr : ""
                
                let dayString = MainBean.shared.changeDateFormat(dayData.date.gregorian.date)
                let day = dayData.date.hijri.day
                let month = dayData.date.hijri.month.en
                let year = dayData.date.hijri.year
                let dayName = "\(day) \(month), \(year)"
                
                let timeInfo = NamazTimeInfos(
                    dayName: dayName,
                    bomdodTime: self.extractTime(dayData.timings.fajr),
                    quyoshTime: self.extractTime(dayData.timings.sunrise),
                    peshinTime: self.extractTime(dayData.timings.dhuhr),
                    asrTime: self.extractTime(dayData.timings.asr),
                    shomTime: self.extractTime(dayData.timings.maghrib),
                    xuftonTime: self.extractTime(dayData.timings.isha),
                    nextDayBomdodTime: self.extractTime(nextDayBomdod),
                    day: dayString
                )
                
                namazInfos.append(timeInfo)
            }
            
            onComplete(namazInfos)
        }
    }
    
    func setRealNamazTime(info:NamazTimeInfos) {
        MainBean.shared.hijDay = info.dayName ?? ""
        MainBean.shared.bomdodTime = info.bomdodTime ?? ""
        MainBean.shared.quyoshTime = info.quyoshTime ?? ""
        MainBean.shared.peshinTime = info.peshinTime ?? ""
        MainBean.shared.asrTime = info.asrTime ?? ""
        MainBean.shared.shomTime = info.shomTime ?? ""
        MainBean.shared.xuftonTime = info.xuftonTime ?? ""
        MainBean.shared.nextDayBomdodTime = info.nextDayBomdodTime ?? ""
        
        self.view().tableView.reloadRows(at: [IndexPath(row: 0, section: 0),IndexPath(row: 1, section: 0)], with: .none)
    }
    
    func extractTime(_ value: String) -> String {
        return value.components(separatedBy: " ").first ?? value
    }
}


// Get Media files
extension MainVC {
    func getMediaFiles() {
        
        if dataManager.fetchAllVideos().isEmpty {
            self.getMediaFiles { resultMedia in
                self.dataManager.insertQuranSurahs(surahs: resultMedia.quran_surahs)
                self.dataManager.insertTasbehs(tasbehs: resultMedia.tasbehs)
                let videoList = resultMedia.video_tutorials.sorted{(r1, r2) -> Bool in
                    r1.id ?? 0 < r2.id ?? 0
                }
                self.dataManager.insertVideos(videos: videoList)
            }
        }
    }
}


// Get Cities
extension MainVC:ChooseCitiesIxResponder,MainBodyIxResponder {
    
    func getCities() {
        self.view().cityOnClick = {
            if self.dataManager.fetchAllRegions().isEmpty {
                self.getCityNames { result in
                    let sortedRegion = result.regions.sorted{(r1, r2) -> Bool in
                        r1.id ?? 0 > r2.id ?? 0
                    }
                    self.regions = sortedRegion
                    self.dataManager.insertRegions(regions: sortedRegion)
                    self.presentCities(regions: sortedRegion)
                }
            } else {
                self.regions = self.dataManager.fetchAllRegions()
                self.presentCities(regions: self.regions)
            }
        }
    }
    
    func presentCities(regions:[Regions]) {
        let vcCard = ChooseCitiesVC()
        vcCard.regions = regions
        vcCard.delegate = self
        self.presentPanModal(vcCard)
    }
   
    func selectedCity(item: Regions) {
        MainBean.shared.selectedCity = item.name ?? ""
        
        // Get period dates for the month
        let startDate = MainBean.shared.getFirstDayOfMonth().replacingOccurrences(of: ".", with: "-")
        let endDate = MainBean.shared.getLastDayOfMonth().replacingOccurrences(of: ".", with: "-")
        
        self.getWholeMonthTimes(long: item.lan ?? "", lati: item.lat ?? "", startDate: startDate, endDate: endDate) { monthlyNamazInfos in
            // Save all month data to Core Data
            self.dataManager.insertNamazInfo(namazInfos: monthlyNamazInfos)
            
            // Set today's namaz time
            let today = MainBean.shared.getTodayDate()
            if let todayInfo = monthlyNamazInfos.first(where: { $0.day == today }) {
                self.setRealNamazTime(info: todayInfo)
            }
        }
    }
}


// MARK: Network
extension MainVC {
    private func getCityNames(success:((CityResponse) -> Void)?) {
        NetworkManager(.noHud).request(MainService.getCityNames) { result in
            BaseNetwork().processResponse(result: result, success: success) { error in
                print("Error: \(error?.message ?? "oшибка")")
               // self.showBaseErrorAlert(subtitle: error?.message ?? "oшибка")
            }
        }
    }
    
    private func getMediaFiles(success:((MediasResponse) -> Void)?) {
        NetworkManager(.noHud).request(MainService.getMediaFiles) { result in
            BaseNetwork().processResponse(result: result, success: success) { error in
                print("Error: \(error?.message ?? "oшибка")")
               // self.showBaseErrorAlert(subtitle: error?.message ?? "oшибка")
            }
        }
    }
    
    private func getTimePeriods(data:NamazPeriodRequest, success:((NamazPeriodResponse) -> Void)?) {
        NetworkManager(.noHud).request(MainService.getTimePeriod(body: data)) { result in
            BaseNetwork().processResponse(result: result, success: success) { error in
                print("Error: \(error?.message ?? "oшибка")")
               // self.showBaseErrorAlert(subtitle: error?.message ?? "oшибка")
            }
        }
    }
}


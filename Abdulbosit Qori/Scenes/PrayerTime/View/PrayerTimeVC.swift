//
//  PrayerTimeVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/5/23.
//

import Foundation
import UIKit
import MyLibrary
import CoreLocation
import UserNotifications

class PrayerTimeVC:UIViewController,ViewSpecificController {
    
    // MARK: - RootView
    typealias RootView = PrayerInnerView
    weak var coordinator: MainCoordinator?
    
    var timer = Timer()
    var secondsLeft = 1
    var hoursLeft = 0
    var minutesLeft = 0
    private var selectedIndex = -1
    var userDefaults = UserDefaults.standard
    private var dataManager = DataManager.shared
    private var notificationManager = PrayerNotificationManager.shared
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
    // MARK: - Lifecycle
    override func loadView() {
        let rootView = PrayerInnerView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "bgMain")
        self.appearanceSettings()
        self.requestNotificationPermission()
        self.getNamazTimesList(date: Date())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        checkForDayChange()
    }
    
    private func appearanceSettings() {
        self.navigationItem.title = "Namoz vaqtlari"
        self.setItems()
        self.view().btnRefresh.addTarget(self, action: #selector(btnLocationRotateClicked), for: .touchUpInside)
        self.view().prayerTimeOnClick = { index, state in
            self.selectedIndex = index
            self.coordinator?.pushToPlayerTimeControl(state: state, vc: self, isSun: index == 2 ? true : false)
        }
        self.view().leftBtnOnClick = { date in
            ImpactGenerator.panModal.generateImpact()
            let previousDate = self.getPreviousDate(date: date)
            self.view().selectedDate = previousDate
            self.getNamazTimesList(date: previousDate)
        }
        
        self.view().rightBtnOnClick = { date in
            ImpactGenerator.panModal.generateImpact()
            let nextDate = self.getNextDate(date: date)
            self.view().selectedDate = nextDate
            self.getNamazTimesList(date: nextDate)
        }
    }
    
    @objc func btnLocationRotateClicked() {
        UIView.animate(withDuration: 0.5) {
            self.view().rotateImg.transform = self.view().rotateImg.transform.rotated(by: .pi)
        }
    }
    
    func getNextDate(date:Date)->Date{
        let now = Calendar.current.dateComponents(in: .current, from: date)
        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
        return Calendar.current.date(from: tomorrow)!
    }
    func getPreviousDate(date:Date)->Date{
        let now = Calendar.current.dateComponents(in: .current, from: date)
        let yesterday = DateComponents(year: now.year, month: now.month, day: now.day! - 1)
        return Calendar.current.date(from: yesterday)!
    }
    
    func getNamazTimesList(date:Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDate = dateFormatter.string(from: date)
        
        let namazInfos = dataManager.fetchNamazDayInfo(day: currentDate)
        
        if !namazInfos.isEmpty {
            if let info = namazInfos.first {
                self.setDateListFromCoreData(info: info)
            }
        } else {
            self.fetchMonthlyDataAndSaveToCD(for: date)
        }
    }
    
    private func setDateListFromCoreData(info: NamazTimeInfos) {
        let dateList = [
            info.bomdodTime ?? "",
            info.quyoshTime ?? "",
            info.peshinTime ?? "",
            info.asrTime ?? "",
            info.shomTime ?? "",
            info.xuftonTime ?? ""
        ]
        self.view().dateList = dateList
    }
    
    private func fetchMonthlyDataAndSaveToCD(for date: Date) {
        let currentLocation = locationManager.location
        let long: String = String(currentLocation?.coordinate.longitude ?? 69.2773884)
        let lati: String = String(currentLocation?.coordinate.latitude ?? 41.3188992)
        
        let startDate = getFirstDayOfMonth(for: date).replacingOccurrences(of: ".", with: "-")
        let endDate = getLastDayOfMonth(for: date).replacingOccurrences(of: ".", with: "-")
        
        self.getWholeMonthTimes(long: long, lati: lati, startDate: startDate, endDate: endDate) { monthlyNamazInfos in
            self.dataManager.insertNamazInfo(namazInfos: monthlyNamazInfos)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let requestedDate = dateFormatter.string(from: date)
            
            if let dayInfo = monthlyNamazInfos.first(where: { $0.day == requestedDate }) {
                self.setDateListFromCoreData(info: dayInfo)
            }
            
            DispatchQueue.main.async {
                self.scheduleAlarms()
            }
        }
    }
    
    private func getFirstDayOfMonth(for date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstDay = calendar.date(from: components)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: firstDay)
    }
    
    private func getLastDayOfMonth(for date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstDay = calendar.date(from: components)!
        let lastDay = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDay)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: lastDay)
    }
    
    func getWholeMonthTimes(long: String, lati: String, startDate: String, endDate: String, onComplete: @escaping(([NamazTimeInfos]) -> ())) {
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
            
            let prayerTimes = response.data
            for (index, dayData) in prayerTimes.enumerated() {
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
    
    func extractTime(_ value: String) -> String {
        return value.components(separatedBy: " ").first ?? value
    }
    
    // MARK: - Notification Management
    private func requestNotificationPermission() {
        notificationManager.checkNotificationPermissions { [weak self] granted in
            if granted {
                self?.scheduleAlarms()
            } else {
                self?.notificationManager.requestNotificationPermission { [weak self] newlyGranted in
                    if newlyGranted {
                        self?.scheduleAlarms()
                    }
                }
            }
        }
    }
    
    private func scheduleAlarms() {
        notificationManager.updateNotificationPreferences()
    }
}


extension PrayerTimeVC: PrayerTimeControlIxResponder{
    func prayerSoundChanged(state: PrayerTimeState) {
        
        switch state {
        case .cilent:
            userDefaults.setValue(String(0), forKey: "sound\(selectedIndex-1)")
            self.view().tableView.reloadData()
        case .vibration:
            userDefaults.setValue(String(1), forKey: "sound\(selectedIndex-1)")
            self.view().tableView.reloadData()
        case .sound:
            userDefaults.setValue(String(2), forKey: "sound\(selectedIndex-1)")
            self.view().tableView.reloadData()
        }
        
        notificationManager.updateNotificationPreferences()
    }
    
    func setItems() {
        let bomdod = MainBean.shared.bomdodTime
        let quyosh = MainBean.shared.quyoshTime
        let peshin = MainBean.shared.peshinTime
        let asr = MainBean.shared.asrTime
        let shom =  MainBean.shared.shomTime
        let xufton = MainBean.shared.xuftonTime
        let nextDayBomdod = MainBean.shared.nextDayBomdodTime
        let currentTime = getCurrentTime()
        
        if checkIfCurrentTimeIsBetween(startTime: bomdod, endTime: quyosh) {
            self.view().prayerType.text = "Quyosh vaqti"
            self.view().prayerTime.text = quyosh
            timeDifference(start: currentTime, end: quyosh)
            self.view().selectedIndex = 0
        } else if checkIfCurrentTimeIsBetween(startTime: quyosh, endTime: peshin) {
            self.view().prayerType.text = "Peshin vaqti"
            self.view().prayerTime.text = peshin
            timeDifference(start: currentTime, end: peshin)
            self.view().selectedIndex = 1
        } else if checkIfCurrentTimeIsBetween(startTime: peshin, endTime: asr) {
            self.view().prayerType.text = "Asr vaqti"
            self.view().prayerTime.text = asr
            timeDifference(start: currentTime, end: asr)
            self.view().selectedIndex = 2
        } else if checkIfCurrentTimeIsBetween(startTime: asr, endTime: shom) {
            self.view().prayerType.text = "Shom vaqti"
            self.view().prayerTime.text = shom
            timeDifference(start: currentTime, end: shom)
            self.view().selectedIndex = 3
        } else if checkIfCurrentTimeIsBetween(startTime: shom, endTime: xufton) {
            self.view().prayerType.text = "Xufton vaqti"
            self.view().prayerTime.text = xufton
            timeDifference(start: currentTime, end: xufton)
            self.view().selectedIndex = 4
        }   else if checkIfCurrentTimeIsBetween(startTime:xufton, endTime: "23:59") || checkIfCurrentTimeIsBetween(startTime: "00:00", endTime: nextDayBomdod) {
            self.view().prayerType.text = "Bomdod"
            if checkIfCurrentTimeIsBetween(startTime:xufton, endTime: "23:59") {
                self.view().prayerTime.text = nextDayBomdod
                timeDifference(start: currentTime, end: nextDayBomdod, needNextDay: true)
            } else {
                self.view().prayerTime.text = bomdod
                timeDifference(start: currentTime, end: bomdod, needNextDay: false)
            }
        }
    }
    
    func getCurrentTime()->String{
        let d = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "uz_Latn_UZ")
        dateFormatter.defaultDate = Calendar.current.startOfDay(for: Date())
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: d)
        return time
    }
    
    func timeDifference(start:String, end:String, needNextDay:Bool = false){
        var hours = Double()
        var minutes = Double()
        if needNextDay {
            guard let start1 = Formatter.today.date(from: start), let end1 = Formatter.today.date(from: "23:59") else {
                return
            }
            guard let start2 = Formatter.today.date(from: "00:00"), let end2 = Formatter.today.date(from: end) else {
                return
            }
            let elapsedTime1 = end1.timeIntervalSince(start1)
            let elapsedTime2 = end2.timeIntervalSince(start2)
            let totalElapsedTime = elapsedTime1 + elapsedTime2
            hours = floor(totalElapsedTime / 60 / 60)
            minutes = floor((totalElapsedTime - (hours * 60 * 60)) / 60)
        } else {
            guard let start = Formatter.today.date(from: start), let end = Formatter.today.date(from: end) else {
                return
            }
            let elapsedTime = end.timeIntervalSince(start)
            hours = floor(elapsedTime / 60 / 60)
            minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        }
       
        self.hoursLeft = Int(hours)
        self.minutesLeft = Int(minutes)
        
        timer = Timer.scheduledTimer(timeInterval: 1.00, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    @objc func onTimerFires(){
        secondsLeft -= 1
        self.view().leftTime.text = String(format: "-%02d:%02d:%02d", hoursLeft, minutesLeft, secondsLeft)
        if secondsLeft <= 0 {
            if minutesLeft != 0{
                secondsLeft = 59
                minutesLeft -= 1
            }
        }
        if minutesLeft <= 0 {
            if hoursLeft != 0{
                minutesLeft = 59
                hoursLeft -= 1
            }
        }
        if(hoursLeft == 0 && minutesLeft == 0 && secondsLeft == 0){
            timer.invalidate()
        }
    }
    
    func checkIfCurrentTimeIsBetween(startTime: String, endTime: String) -> Bool {
        guard let start = Formatter.today.date(from: startTime),
              let end = Formatter.today.date(from: endTime) else {
            return false
        }
        return DateInterval(start: start, end: end).contains(Date())
    }
}

// MARK: Network
extension PrayerTimeVC {
    private func getTimePeriods(data: NamazPeriodRequest, success: ((NamazPeriodResponse) -> Void)?) {
        NetworkManager(.noHud).request(MainService.getTimePeriod(body: data)) { result in
            BaseNetwork().processResponse(result: result, success: success) { error in
                print("Error: \(error?.message ?? "oшибка")")
            }
        }
    }
}

// MARK: - Daily Update Management
extension PrayerTimeVC {
    private func checkForDayChange() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let todayString = dateFormatter.string(from: today)
        
        let todayInfos = dataManager.fetchNamazDayInfo(day: todayString)
        if todayInfos.isEmpty {
            fetchMonthlyDataAndSaveToCD(for: today)
        }
        
        if Calendar.current.component(.day, from: today) >= Calendar.current.range(of: .day, in: .month, for: today)!.count - 3 {
            let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: today) ?? today
            let nextMonthString = dateFormatter.string(from: nextMonth)
            
            let nextMonthInfos = dataManager.fetchNamazDayInfo(day: nextMonthString)
            if nextMonthInfos.isEmpty {
                fetchMonthlyDataAndSaveToCD(for: nextMonth)
            }
        }
    }
}

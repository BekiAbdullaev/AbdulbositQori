//
//  QiblaVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary
import CoreLocation

class QiblaVC:UIViewController,ViewSpecificController {
    
    // MARK: - RootView
    typealias RootView = QiblaRootView
    weak var coordinator: MainCoordinator?
    
    let locationDelegate = LocationDelegate()
    var latestLocation: CLLocation? = nil
    var yourLocationBearing: CGFloat { return latestLocation?.bearingToLocationRadian(self.yourLocation) ?? 0 }
    var yourLocation: CLLocation = CLLocation(latitude: 21.4225, longitude: 39.8262)
    
    var timer = Timer()
    var secondsLeft = 1
    var hoursLeft = 0
    var minutesLeft = 0
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
        // MARK: - Lifecycle
    override func loadView() {
        let rootView = QiblaRootView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "bgMain")
        
        self.appearanceSettings()
        self.setCompus()
        self.setItems()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
    private func appearanceSettings() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Qibla"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if MainBean.shared.needCompus {
                let popup = CompusUseageVC()
                self.presentPanModal(popup)
                MainBean.shared.needCompus = false
            }
        }
    }

    private func orientationAdjustment() -> CGFloat {
        let isFaceDown: Bool = {
            switch UIDevice.current.orientation {
            case .faceDown: return true
            default: return false
            }
        }()
      
        let adjAngle: CGFloat = {
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:  return 90
            case .landscapeRight: return -90
            case .portrait, .unknown: return 0
            case .portraitUpsideDown: return isFaceDown ? 180 : -180
            }
        }()
        return adjAngle
    }
    
    func setCompus(){
        locationManager.delegate = locationDelegate
        let currentLocation = locationManager.location
        let long:String = String(String(currentLocation?.coordinate.longitude ?? 0.0).prefix(5))
        let lati:String = String(String(currentLocation?.coordinate.latitude ?? 0.0).prefix(5))
        self.view().userLocation.text = "Toshkent (shim.keng: \(lati) / sharq.uzun: \(long))"
        
        locationDelegate.locationCallback = { location in
          self.latestLocation = location
        }
        
        locationDelegate.headingCallback = { newHeading in
          
            func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
                let heading: CGFloat = {
                    let originalHeading = self.yourLocationBearing - newAngle.degreesToRadians
                    switch UIDevice.current.orientation {
                    case .faceDown: return -originalHeading
                    default: return originalHeading
                    }
                }()
                return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
            }
          
            UIView.animate(withDuration: 0.5) {
                let angle = computeNewAngle(with: CGFloat(newHeading))
                self.view().compusImage.transform = CGAffineTransform(rotationAngle: angle)
            }
        }
    }
}


extension QiblaVC {
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
        } else if checkIfCurrentTimeIsBetween(startTime: quyosh, endTime: peshin) {
            self.view().prayerType.text = "Peshin vaqti"
            self.view().prayerTime.text = peshin
            timeDifference(start: currentTime, end: peshin)
        } else if checkIfCurrentTimeIsBetween(startTime: peshin, endTime: asr) {
            self.view().prayerType.text = "Asr vaqti"
            self.view().prayerTime.text = asr
            timeDifference(start: currentTime, end: asr)
        } else if checkIfCurrentTimeIsBetween(startTime: asr, endTime: shom) {
            self.view().prayerType.text = "Shom vaqti"
            self.view().prayerTime.text = shom
            timeDifference(start: currentTime, end: shom)
        } else if checkIfCurrentTimeIsBetween(startTime: shom, endTime: xufton) {
            self.view().prayerType.text = "Xufton vaqti"
            self.view().prayerTime.text = xufton
            timeDifference(start: currentTime, end: xufton)
        }  else if checkIfCurrentTimeIsBetween(startTime:xufton, endTime: "23:59") || checkIfCurrentTimeIsBetween(startTime: "00:00", endTime: nextDayBomdod) {
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

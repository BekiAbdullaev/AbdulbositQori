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

class QiblaVC: UIViewController, ViewSpecificController {
    
    // MARK: - RootView
    typealias RootView = QiblaRootView
    weak var coordinator: MainCoordinator?
    
    let locationDelegate = LocationDelegate()
    var latestLocation: CLLocation? = nil
    var yourLocationBearing: CGFloat { return latestLocation?.bearingToLocationRadian(self.yourLocation) ?? 0 }
    var yourLocation: CLLocation = CLLocation(latitude: 21.4225, longitude: 39.8262)
    
    var prayerTimer: Timer?
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
    
    deinit {
        prayerTimer?.invalidate()
        prayerTimer = nil
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    private func appearanceSettings() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Qibla"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
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
            if #available(iOS 13.0, *) {
                guard let windowScene = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first else {
                    return 0
                }
                switch windowScene.interfaceOrientation {
                case .landscapeLeft:  return 90
                case .landscapeRight: return -90
                case .portrait, .unknown: return 0
                case .portraitUpsideDown: return isFaceDown ? 180 : -180
                @unknown default: return 0
                }
            } else {
                return 0
            }
        }()
        return adjAngle
    }
    
    func setCompus() {
        locationManager.delegate = locationDelegate
        let currentLocation = locationManager.location
        let long = String(String(currentLocation?.coordinate.longitude ?? AppConstants.DefaultCoordinates.longitude).prefix(5))
        let lati = String(String(currentLocation?.coordinate.latitude ?? AppConstants.DefaultCoordinates.latitude).prefix(5))
        self.view().userLocation.text = "Toshkent (shim.keng: \(lati) / sharq.uzun: \(long))"
        
        locationDelegate.locationCallback = { [weak self] location in
            self?.latestLocation = location
        }
        
        locationDelegate.headingCallback = { [weak self] newHeading in
            guard let self = self else { return }
            
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
        let shom = MainBean.shared.shomTime
        let xufton = MainBean.shared.xuftonTime
        let nextDayBomdod = MainBean.shared.nextDayBomdodTime
        let currentTime = PrayerTimeHelper.getCurrentTime()
        
        if PrayerTimeHelper.isCurrentTimeBetween(startTime: bomdod, endTime: quyosh) {
            self.view().prayerType.text = AppConstants.PrayerNames.quyosh
            self.view().prayerTime.text = quyosh
            startCountdown(start: currentTime, end: quyosh)
        } else if PrayerTimeHelper.isCurrentTimeBetween(startTime: quyosh, endTime: peshin) {
            self.view().prayerType.text = AppConstants.PrayerNames.peshin
            self.view().prayerTime.text = peshin
            startCountdown(start: currentTime, end: peshin)
        } else if PrayerTimeHelper.isCurrentTimeBetween(startTime: peshin, endTime: asr) {
            self.view().prayerType.text = AppConstants.PrayerNames.asr
            self.view().prayerTime.text = asr
            startCountdown(start: currentTime, end: asr)
        } else if PrayerTimeHelper.isCurrentTimeBetween(startTime: asr, endTime: shom) {
            self.view().prayerType.text = AppConstants.PrayerNames.shom
            self.view().prayerTime.text = shom
            startCountdown(start: currentTime, end: shom)
        } else if PrayerTimeHelper.isCurrentTimeBetween(startTime: shom, endTime: xufton) {
            self.view().prayerType.text = AppConstants.PrayerNames.xufton
            self.view().prayerTime.text = xufton
            startCountdown(start: currentTime, end: xufton)
        } else if PrayerTimeHelper.isCurrentTimeBetween(startTime: xufton, endTime: "23:59") ||
                    PrayerTimeHelper.isCurrentTimeBetween(startTime: "00:00", endTime: nextDayBomdod) {
            self.view().prayerType.text = AppConstants.PrayerNames.bomdod
            if PrayerTimeHelper.isCurrentTimeBetween(startTime: xufton, endTime: "23:59") {
                self.view().prayerTime.text = nextDayBomdod
                startCountdown(start: currentTime, end: nextDayBomdod, needNextDay: true)
            } else {
                self.view().prayerTime.text = bomdod
                startCountdown(start: currentTime, end: bomdod, needNextDay: false)
            }
        }
    }
    
    private func startCountdown(start: String, end: String, needNextDay: Bool = false) {
        prayerTimer?.invalidate()
        
        guard let timeDiff = PrayerTimeHelper.calculateTimeDifference(start: start, end: end, needNextDay: needNextDay) else {
            return
        }
        
        self.hoursLeft = timeDiff.hours
        self.minutesLeft = timeDiff.minutes
        self.secondsLeft = 59
        
        prayerTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.onTimerFires()
        }
    }
    
    private func onTimerFires() {
        secondsLeft -= 1
        self.view().leftTime.text = String(format: "-%02d:%02d:%02d", hoursLeft, minutesLeft, secondsLeft)
        if secondsLeft <= 0 {
            if minutesLeft != 0 {
                secondsLeft = 59
                minutesLeft -= 1
            }
        }
        if minutesLeft <= 0 {
            if hoursLeft != 0 {
                minutesLeft = 59
                hoursLeft -= 1
            }
        }
        if hoursLeft == 0 && minutesLeft == 0 && secondsLeft == 0 {
            prayerTimer?.invalidate()
            prayerTimer = nil
        }
    }
}


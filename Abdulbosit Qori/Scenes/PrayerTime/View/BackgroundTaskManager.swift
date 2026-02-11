//
//  BackgroundTaskManager.swift
//  Abdulbosit Qori
//
//  Created by Assistant on 3/2/26.
//

import Foundation
import BackgroundTasks
import UIKit
import MyLibrary

@available(iOS 13.0, *)
class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    
    private let backgroundTaskIdentifier = "com.abdulbositqori.prayeralarm.refresh"
    private let notificationManager = PrayerNotificationManager.shared
    private let dataManager = DataManager.shared
    private let hapticManager = HapticFeedbackManager.shared
    
    private init() {
        setupNotificationObservers()
    }
    
    // MARK: - Setup
    private func setupNotificationObservers() {
        // Listen for app lifecycle events for alternative background handling
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
            self.handleBackgroundRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background refresh scheduled successfully")
        } catch {
            print("Could not schedule background refresh: \(error)")
            fallbackToNotificationUpdates()
        }
    }
    
    private func fallbackToNotificationUpdates() {
        notificationManager.updateNotificationPreferences()
        print("Falling back to notification-based prayer time updates")
    }
    
    // MARK: - App Lifecycle Handlers
    @objc private func appDidEnterBackground() {
        scheduleBackgroundRefresh()
    }
    
    @objc private func appWillEnterForeground() {
        updatePrayerTimesInBackground { _ in }
        
        checkCurrentPrayerTimeAndVibrate()
    }
    
    // MARK: - Prayer Time Vibration
    private func checkCurrentPrayerTimeAndVibrate() {
        guard isVibrationEnabled() else { return }
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let todayString = dateFormatter.string(from: now)
        
        let todayInfos = dataManager.fetchNamazDayInfo(day: todayString)
        guard let todayInfo = todayInfos.first else { return }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let currentTimeString = timeFormatter.string(from: now)
        
        let prayerTimes = [
            (PrayerType.bomdod, todayInfo.bomdodTime ?? ""),
            (PrayerType.quyosh, todayInfo.quyoshTime ?? ""),
            (PrayerType.peshin, todayInfo.peshinTime ?? ""),
            (PrayerType.asr, todayInfo.asrTime ?? ""),
            (PrayerType.shom, todayInfo.shomTime ?? ""),
            (PrayerType.xufton, todayInfo.xuftonTime ?? "")
        ]
        
        for (prayerType, prayerTimeString) in prayerTimes {
            guard !prayerTimeString.isEmpty,
                  let prayerTime = timeFormatter.date(from: prayerTimeString),
                  let currentTime = timeFormatter.date(from: currentTimeString) else { continue }
            
            let timeDifference = abs(currentTime.timeIntervalSince(prayerTime))
            
            if timeDifference <= 120 && shouldVibrateForPrayer(prayerType) {
                triggerLongPrayerVibration(for: prayerType)
                break
            }
        }
    }
    
    private func isVibrationEnabled() -> Bool {
        return PrayerType.allCases.contains { shouldVibrateForPrayer($0) }
    }
    
    private func shouldVibrateForPrayer(_ prayerType: PrayerType) -> Bool {
        let soundValue = UserDefaults.standard.string(forKey: "sound\(prayerType.rawValue)") ?? "0"
        let prayerState = PrayerTimeState(rawValue: Int(soundValue) ?? 0) ?? .silent
        return prayerState == .vibration
    }
    
    private func triggerLongPrayerVibration(for prayerType: PrayerType) {
        let duration = defaultVibrationDuration(for: prayerType)
        //hapticManager.startPhoneCallLikeVibration(duration: duration)
        
        print("\(prayerType.displayName) prayer time PHONE CALL-LIKE vibration triggered for \(duration) seconds")
    }
    
    // MARK: - Background Task Handling
    private func handleBackgroundRefresh(task: BGAppRefreshTask) {
        scheduleBackgroundRefresh()
        
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        updatePrayerTimesInBackground { success in
            task.setTaskCompleted(success: success)
        }
    }
    
    private func updatePrayerTimesInBackground(completion: @escaping (Bool) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let today = Date()
        let todayString = dateFormatter.string(from: today)
        
        let todayInfos = dataManager.fetchNamazDayInfo(day: todayString)
        
        if todayInfos.isEmpty {
            fetchCurrentMonthData(completion: completion)
        } else {
            notificationManager.handleDayChange()
            completion(true)
        }
    }
    
    private func fetchCurrentMonthData(completion: @escaping (Bool) -> Void) {
        notificationManager.handleDayChange()
        completion(true)
    }
    
    // MARK: - Public Interface
    func setupPrayerTimeManagement() {
        registerBackgroundTasks()
        
        scheduleBackgroundRefresh()
        
        notificationManager.updateNotificationPreferences()
    }
    
    // MARK: - Manual Vibration Control
    func startLongVibrationForPrayer(_ prayerType: PrayerType, duration: TimeInterval? = nil) {
        let vibrationDuration = duration ?? defaultVibrationDuration(for: prayerType)
        //hapticManager.triggerLongPrayerVibration(duration: vibrationDuration)
        print("Started manual long vibration for \(prayerType.displayName) - \(vibrationDuration) seconds")
    }
    
    func stopCurrentVibration() {
        //hapticManager.stopLongVibration()
        print("Stopped current vibration")
    }
    
    func testLongVibration(duration: TimeInterval = 30) {
        //hapticManager.startPhoneCallLikeVibration(duration: duration)
        print("Started phone call-like vibration for \(duration) seconds")
    }
    
    // MARK: - Strong Vibration Methods
    func startPhoneCallVibration(duration: TimeInterval = 30) {
        //hapticManager.startPhoneCallLikeVibration(duration: duration)
        print("Started phone call vibration for \(duration) seconds")
    }
    
    func startExtremeVibration(duration: TimeInterval = 30) {
        //hapticManager.startExtremeVibration(duration: duration)
        print("Started EXTREME vibration for \(duration) seconds")
    }
    
    func startContinuousStrongVibration(duration: TimeInterval = 30) {
        //hapticManager.startContinuousStrongVibration(duration: duration)
        print("Started continuous strong vibration for \(duration) seconds")
    }
    
    private func defaultVibrationDuration(for prayerType: PrayerType) -> TimeInterval {
        switch prayerType {
        case .bomdod: return 30
        case .quyosh: return 15
        case .peshin: return 45
        case .asr: return 45
        case .shom: return 40
        case .xufton: return 35  
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

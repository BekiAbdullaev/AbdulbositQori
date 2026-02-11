//
//  PrayerNotificationManager.swift
//  Abdulbosit Qori
//
//  Created by Assistant on 3/2/26.
//

import Foundation
import UserNotifications
import AVFoundation
import UIKit
import MyLibrary

enum PrayerType: Int, CaseIterable {
    case bomdod = 0
    case quyosh = 1
    case peshin = 2
    case asr = 3
    case shom = 4
    case xufton = 5
    
    var displayName: String {
        switch self {
        case .bomdod: return "Bomdod"
        case .quyosh: return "Quyosh"
        case .peshin: return "Peshin"
        case .asr: return "Asr"
        case .shom: return "Shom"
        case .xufton: return "Xufton"
        }
    }
    
    var notificationIdentifier: String {
        return "prayer_\(rawValue)"
    }
}

enum PrayerTimeState: Int {
    case cilent = 0
    case vibration = 1
    case sound = 2
}

class PrayerNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = PrayerNotificationManager()
    private let userDefaults = UserDefaults.standard
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }

    // MARK: - Schedule Prayer Notifications
    func schedulePrayerNotifications(prayerInfo: NamazTimeInfos, for date: Date = Date()) {
        cancelNotificationsForDate(date)
        
        let prayerTimes = [
            (PrayerType.bomdod, prayerInfo.bomdodTime ?? ""),
            (PrayerType.quyosh, prayerInfo.quyoshTime ?? ""),
            (PrayerType.peshin, prayerInfo.peshinTime ?? ""),
            (PrayerType.asr, prayerInfo.asrTime ?? ""),
            (PrayerType.shom, prayerInfo.shomTime ?? ""),
            (PrayerType.xufton, prayerInfo.xuftonTime ?? "")
        ]
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        for (prayerType, timeString) in prayerTimes {
            guard !timeString.isEmpty,
                  let prayerTime = dateFormatter.date(from: timeString) else { continue }
            
            let prayerState = getPrayerState(for: prayerType)
            
            if prayerState != .cilent {
                let prayerComponents = calendar.dateComponents([.hour, .minute], from: prayerTime)
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                dateComponents.hour = prayerComponents.hour
                dateComponents.minute = prayerComponents.minute
                dateComponents.second = 0
                
                if let scheduledDate = calendar.date(from: dateComponents),
                   scheduledDate > Date() {
                    scheduleNotification(
                        for: prayerType,
                        at: scheduledDate,
                        state: prayerState,
                        date: date
                    )
                }
            }
        }
    }
    
    private func scheduleNotification(for prayerType: PrayerType, at date: Date, state: PrayerTimeState, date scheduledDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "\(prayerType.displayName) vaqti"
        content.body = "Namoz vaqti kirdi"
        content.categoryIdentifier = "PRAYER_NOTIFICATION"
        
        switch state {
        case .sound:
            if let soundName = getCustomSoundFileName() {
                content.sound = UNNotificationSound(named: UNNotificationSoundName(soundName))
            } else {
                content.sound = .default
            }
            
        case .vibration:
            content.sound = nil
            content.userInfo = ["vibrationMode": true]
            
        case .cilent:
            return
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let identifier = "\(prayerType.notificationIdentifier)_\(dateFormatter(scheduledDate))"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification for \(prayerType.displayName): \(error)")
            } else {
                print("Successfully scheduled \(state == .sound ? "sound" : "vibration") notification for \(prayerType.displayName)")
            }
        }
    }
    
    // MARK: - Helper Methods
    private func getPrayerState(for prayerType: PrayerType) -> PrayerTimeState {
        let soundValue = userDefaults.string(forKey: "sound\(prayerType.rawValue)") ?? "0"
        return PrayerTimeState(rawValue: Int(soundValue) ?? 0) ?? .cilent
    }
    
    private func getCustomSoundFileName() -> String? {
        let soundFiles = [
            "AZON_ALARM.wav",
            "AZON_ALARM.wav",
            "AZON_ALARM.mp3",
            "AZON_ALARM.mp3",
            "AZON_ALARM.caf",
            "AZON_ALARM.caf"
        ]
        
        for soundName in soundFiles {
            let fileName = String(soundName.split(separator: ".")[0])
            let fileExtension = String(soundName.split(separator: ".")[1])
            
            if Bundle.main.url(forResource: fileName, withExtension: fileExtension) != nil {
                return soundName
            }
        }
        
        return nil
    }
    
    private func cancelNotificationsForDate(_ date: Date) {
        let dateString = dateFormatter(date)
        let identifiers = PrayerType.allCases.map { "\($0.notificationIdentifier)_\(dateString)" }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    private func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // MARK: - Public Methods
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func scheduleNextDayAlarms() {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let dataManager = DataManager.shared
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let tomorrowString = dateFormatter.string(from: tomorrow)
        
        let namazInfos = dataManager.fetchNamazDayInfo(day: tomorrowString)
        if let tomorrowInfo = namazInfos.first {
            schedulePrayerNotifications(prayerInfo: tomorrowInfo, for: tomorrow)
        }
    }
    
    func updateNotificationPreferences() {
        cancelAllNotifications()
        
        let dataManager = DataManager.shared
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        for i in 0...7 {
            let futureDate = Calendar.current.date(byAdding: .day, value: i, to: Date()) ?? Date()
            let futureDateString = dateFormatter.string(from: futureDate)
            
            let futureInfos = dataManager.fetchNamazDayInfo(day: futureDateString)
            if let futureInfo = futureInfos.first {
                schedulePrayerNotifications(prayerInfo: futureInfo, for: futureDate)
            }
        }
    }
    
    func checkNotificationPermissions(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    // MARK: - Setup Method
    func setupNotificationCategories() {
        let categoryIdentifier = "PRAYER_NOTIFICATION"
        let category = UNNotificationCategory(
            identifier: categoryIdentifier,
            actions: [],
            intentIdentifiers: [],
            options: []
        )
        
        notificationCenter.setNotificationCategories([category])
    }
}

// MARK: - Daily Update Handler
extension PrayerNotificationManager {
    func handleDayChange() {
        scheduleNextDayAlarms()
        
        cleanupOldNotifications()
    }
    
    private func cleanupOldNotifications() {
        notificationCenter.getPendingNotificationRequests { requests in
            let now = Date()
            let calendar = Calendar.current
            
            let expiredIdentifiers = requests.compactMap { request -> String? in
                guard let trigger = request.trigger as? UNCalendarNotificationTrigger,
                      let triggerDate = trigger.nextTriggerDate(),
                      triggerDate < now else { return nil }
                return request.identifier
            }
            
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: expiredIdentifiers)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension PrayerNotificationManager {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let isVibrationMode = userInfo["vibrationMode"] as? Bool, isVibrationMode {
            triggerHapticFeedback()
            completionHandler([.alert, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let isVibrationMode = userInfo["vibrationMode"] as? Bool, isVibrationMode {
            triggerHapticFeedback()
        }
        
        completionHandler()
    }
    
    private func triggerHapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let impactFeedback2 = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback2.impactOccurred()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let impactFeedback3 = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback3.impactOccurred()
        }
    }
}

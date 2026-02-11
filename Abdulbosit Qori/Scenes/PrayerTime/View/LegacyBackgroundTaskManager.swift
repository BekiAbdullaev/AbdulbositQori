//
//  LegacyBackgroundTaskManager.swift
//  Abdulbosit Qori
//
//  Created by Assistant on 3/2/26.
//

import Foundation
import UIKit

class LegacyBackgroundTaskManager {
    static let shared = LegacyBackgroundTaskManager()
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    private let notificationManager = PrayerNotificationManager.shared
    
    private init() {}
    
    func registerForBackgroundRefresh() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc private func applicationDidEnterBackground() {
        beginBackgroundTask()
    }
    
    @objc private func applicationWillEnterForeground() {
        endBackgroundTask()
        
        notificationManager.handleDayChange()
    }
    
    private func beginBackgroundTask() {
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: "PrayerTimeUpdate") {
            self.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTaskIdentifier != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            backgroundTaskIdentifier = .invalid
        }
    }
}

// MARK: - Notification Observer for Day Changes
extension LegacyBackgroundTaskManager {
    func setupDayChangeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dayChanged),
            name: .NSCalendarDayChanged,
            object: nil
        )
    }
    
    @objc private func dayChanged() {
        notificationManager.handleDayChange()
    }
}

//
//  Constants.swift
//  Abdulbosit Qori
//
//  Barcha loyiha bo'ylab ishlatiladigan konstantalar
//

import Foundation
import CoreLocation

// MARK: - App Constants
enum AppConstants {
    
    // MARK: - UserDefaults Keys
    enum UserDefaultsKeys {
        static let lastNotificationUpdate = "lastNotificationUpdate"
        
        /// Namoz ovoz sozlamasi uchun kalit. Index qo'shib ishlatiladi: "prayerSound_0", "prayerSound_1"...
        static func prayerSound(for index: Int) -> String {
            return "sound\(index)"
        }
    }
    
    // MARK: - Default Coordinates (Toshkent)
    enum DefaultCoordinates {
        static let latitude: Double = 41.3188992
        static let longitude: Double = 69.2773884
        
        static var location: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    // MARK: - Date Formats
    enum DateFormats {
        static let dayMonthYear = "dd.MM.yyyy"
        static let hourMinute = "HH:mm"
        static let yearMonthDay = "yyyy-MM-dd"
    }
    
    // MARK: - Prayer Names
    enum PrayerNames {
        static let bomdod = "Bomdod"
        static let quyosh = "Quyosh vaqti"
        static let peshin = "Peshin vaqti"
        static let asr = "Asr vaqti"
        static let shom = "Shom vaqti"
        static let xufton = "Xufton vaqti"
    }
    
    // MARK: - Notification
    enum Notification {
        static let prayerCategoryIdentifier = "PRAYER_NOTIFICATION"
    }
}

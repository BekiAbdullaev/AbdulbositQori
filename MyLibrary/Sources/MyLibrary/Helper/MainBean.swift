//
//  File.swift
//  MyLibrary
//
//  Created by Abdullaev Bekzod on 20/01/25.
//

import Foundation
import UIKit

public class MainBean: @unchecked Sendable {
    
    // MARK: - Shared instance of MainBean
    public static let shared = MainBean()
    public var needCompus = true
    public var hijDay = ""
    public var bomdodTime = ""
    public var quyoshTime = ""
    public var peshinTime = ""
    public var asrTime = ""
    public var shomTime = ""
    public var xuftonTime = ""
    public var nextDayBomdodTime = ""
    public var selectedCity = "Shaharni tanlang"
//    public var quranSurahs = [MediasFiles]()
//    public var prayerTutorials = [MediasFiles]()
//    public var videoTutorials = [MediasFiles]()
//    public var tasbehs = [MediasFiles]()
    public var namazs = [NamazFiles]()
    public var isPlayStarted = false
    public var maxAudioValue:PrayerAudioModel = PrayerAudioModel(value: 0.0, index: -1)
    public var currentAudioValue:PrayerAudioModel = PrayerAudioModel(value: 0.0, index: -1)
    public var needStopFirebase = false
    
    
    // Get Month days
    private func getAllDaysUntilNextMonth() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let today = Date()
        var currentDate = today
        
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: today),
           let startOfNextMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: nextMonth)) {
            while currentDate < startOfNextMonth {
                dates.append(currentDate)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
        }
        return dates
    }
    
    public func getPairedDaysUntilNextMonth() -> [[String]] {
        var days = [String]()
        let allDays = getAllDaysUntilNextMonth()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        for date in allDays {
            days.append(dateFormatter.string(from: date))
        }
        
        return createOverlappingPairs(days)
    }
    
    func createOverlappingPairs<String>(_ array: [String]) -> [[String]] {
        var result: [[String]] = []
        
        for i in 0..<array.count {
            if i < array.count - 1 {
                result.append([array[i], array[i + 1]])
            } else {
                result.append([array[i], array[i]])
            }
        }
        
        return result
    }
    
    
    // Get Month LastDay
    public func isFirstDayOfMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        return day == 1
    }
    
    // Get Tome Zone
    public func getTimeZone() -> String {
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "+5"}
        return String(localTimeZoneAbbreviation.suffix(2))
    }
    
    public func getTodayDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    public func getTomorrowDate()->String{
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
        let dateTomorrow = Calendar.current.date(from: tomorrow)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: dateTomorrow)
    }
    
    public func changeDateFormat(_ date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"

        guard let dateObj = inputFormatter.date(from: date) else {
            return date
        }

        return outputFormatter.string(from: dateObj)
    }
    
    // Get First Day of Month
    public func getFirstDayOfMonth() -> String {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: startOfMonth)
    }
    
    // Get Last Day of Month
    public func getLastDayOfMonth() -> String {
        let calendar = Calendar.current
        let now = Date()
        if let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end {
            let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: endOfMonth) ?? now
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: lastDayOfMonth)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: now)
    }
}

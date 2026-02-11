//
//  PrayerTimeHelper.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 11/02/26.
//

import Foundation
import Foundation
import UIKit
import MyLibrary

// MARK: - Prayer Time Display Protocol
/// Namoz vaqti timer va display logikasini ko'rsatadigan VC'lar uchun protocol
protocol PrayerTimeDisplayable: AnyObject {
    var prayerTimer: Timer? { get set }
    var secondsLeft: Int { get set }
    var hoursLeft: Int { get set }
    var minutesLeft: Int { get set }
    
    /// UI elementlarini yangilash uchun — har bir VC o'zicha implement qiladi
    func updatePrayerTimeLabel(type: String, time: String, selectedIndex: Int)
    func updateCountdownLabel(text: String)
}

// MARK: - Prayer Time Helper
final class PrayerTimeHelper {
    
    // MARK: - Get Current Time
    /// Hozirgi vaqtni "HH:mm" formatida qaytaradi
    static func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "uz_Latn_UZ")
        dateFormatter.defaultDate = Calendar.current.startOfDay(for: Date())
        dateFormatter.dateFormat = AppConstants.DateFormats.hourMinute
        return dateFormatter.string(from: Date())
    }
    
    // MARK: - Check Time Range
    /// Hozirgi vaqt berilgan oraliqda ekanligini tekshiradi
    static func isCurrentTimeBetween(startTime: String, endTime: String) -> Bool {
        guard let start = Formatter.today.date(from: startTime),
              let end = Formatter.today.date(from: endTime) else {
            return false
        }
        return DateInterval(start: start, end: end).contains(Date())
    }
    
    // MARK: - Calculate Time Difference
    /// Ikki vaqt orasidagi farqni hisoblaydi va (hours, minutes) qaytaradi
    static func calculateTimeDifference(start: String, end: String, needNextDay: Bool = false) -> (hours: Int, minutes: Int)? {
        var hours: Double = 0
        var minutes: Double = 0
        
        if needNextDay {
            guard let start1 = Formatter.today.date(from: start),
                  let end1 = Formatter.today.date(from: "23:59"),
                  let start2 = Formatter.today.date(from: "00:00"),
                  let end2 = Formatter.today.date(from: end) else {
                return nil
            }
            let elapsedTime1 = end1.timeIntervalSince(start1)
            let elapsedTime2 = end2.timeIntervalSince(start2)
            let totalElapsedTime = elapsedTime1 + elapsedTime2
            hours = floor(totalElapsedTime / 3600)
            minutes = floor((totalElapsedTime - (hours * 3600)) / 60)
        } else {
            guard let startDate = Formatter.today.date(from: start),
                  let endDate = Formatter.today.date(from: end) else {
                return nil
            }
            let elapsedTime = endDate.timeIntervalSince(startDate)
            hours = floor(elapsedTime / 3600)
            minutes = floor((elapsedTime - (hours * 3600)) / 60)
        }
        
        return (Int(hours), Int(minutes))
    }
    
    // MARK: - Determine Current Prayer
    /// Hozirgi namoz vaqtini aniqlaydi va callback orqali natijani qaytaradi
    static func resolveCurrentPrayer(
        delegate: PrayerTimeDisplayable,
        prayerTypeLabel: (String) -> Void,
        prayerTimeLabel: (String) -> Void,
        selectedIndexCallback: (Int) -> Void
    ) {
        let bomdod = MainBean.shared.bomdodTime
        let quyosh = MainBean.shared.quyoshTime
        let peshin = MainBean.shared.peshinTime
        let asr = MainBean.shared.asrTime
        let shom = MainBean.shared.shomTime
        let xufton = MainBean.shared.xuftonTime
        let nextDayBomdod = MainBean.shared.nextDayBomdodTime
        let currentTime = getCurrentTime()
        
        if isCurrentTimeBetween(startTime: bomdod, endTime: quyosh) {
            prayerTypeLabel(AppConstants.PrayerNames.quyosh)
            prayerTimeLabel(quyosh)
            startCountdown(delegate: delegate, start: currentTime, end: quyosh)
            selectedIndexCallback(0)
        } else if isCurrentTimeBetween(startTime: quyosh, endTime: peshin) {
            prayerTypeLabel(AppConstants.PrayerNames.peshin)
            prayerTimeLabel(peshin)
            startCountdown(delegate: delegate, start: currentTime, end: peshin)
            selectedIndexCallback(1)
        } else if isCurrentTimeBetween(startTime: peshin, endTime: asr) {
            prayerTypeLabel(AppConstants.PrayerNames.asr)
            prayerTimeLabel(asr)
            startCountdown(delegate: delegate, start: currentTime, end: asr)
            selectedIndexCallback(2)
        } else if isCurrentTimeBetween(startTime: asr, endTime: shom) {
            prayerTypeLabel(AppConstants.PrayerNames.shom)
            prayerTimeLabel(shom)
            startCountdown(delegate: delegate, start: currentTime, end: shom)
            selectedIndexCallback(3)
        } else if isCurrentTimeBetween(startTime: shom, endTime: xufton) {
            prayerTypeLabel(AppConstants.PrayerNames.xufton)
            prayerTimeLabel(xufton)
            startCountdown(delegate: delegate, start: currentTime, end: xufton)
            selectedIndexCallback(4)
        } else if isCurrentTimeBetween(startTime: xufton, endTime: "23:59") ||
                    isCurrentTimeBetween(startTime: "00:00", endTime: nextDayBomdod) {
            prayerTypeLabel(AppConstants.PrayerNames.bomdod)
            if isCurrentTimeBetween(startTime: xufton, endTime: "23:59") {
                prayerTimeLabel(nextDayBomdod)
                startCountdown(delegate: delegate, start: currentTime, end: nextDayBomdod, needNextDay: true)
            } else {
                prayerTimeLabel(bomdod)
                startCountdown(delegate: delegate, start: currentTime, end: bomdod, needNextDay: false)
            }
        }
    }
    
    // MARK: - Timer Management
    /// Timer'ni boshlaydi va delegatga ulaydi
    static func startCountdown(delegate: PrayerTimeDisplayable, start: String, end: String, needNextDay: Bool = false) {
        // Avvalgi timer'ni to'xtatish
        delegate.prayerTimer?.invalidate()
        delegate.prayerTimer = nil
        
        guard let timeDiff = calculateTimeDifference(start: start, end: end, needNextDay: needNextDay) else {
            return
        }
        
        delegate.hoursLeft = timeDiff.hours
        delegate.minutesLeft = timeDiff.minutes
        delegate.secondsLeft = 59
        
        delegate.prayerTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak delegate] timer in
            guard let delegate = delegate else {
                timer.invalidate()
                return
            }
            PrayerTimeHelper.handleTimerTick(delegate: delegate)
        }
    }
    
    /// Timer har soniyada chaqiriladigan logika
    static func handleTimerTick(delegate: PrayerTimeDisplayable) {
        delegate.secondsLeft -= 1
        
        let text = String(format: "-%02d:%02d:%02d", delegate.hoursLeft, delegate.minutesLeft, delegate.secondsLeft)
        delegate.updateCountdownLabel(text: text)
        
        if delegate.secondsLeft <= 0 {
            if delegate.minutesLeft > 0 {
                delegate.secondsLeft = 59
                delegate.minutesLeft -= 1
            } else if delegate.hoursLeft > 0 {
                delegate.hoursLeft -= 1
                delegate.minutesLeft = 59
                delegate.secondsLeft = 59
            }
        }
        
        if delegate.minutesLeft <= 0 && delegate.hoursLeft > 0 && delegate.secondsLeft <= 0 {
            delegate.minutesLeft = 59
            delegate.hoursLeft -= 1
        }
        
        if delegate.hoursLeft == 0 && delegate.minutesLeft == 0 && delegate.secondsLeft == 0 {
            delegate.prayerTimer?.invalidate()
            delegate.prayerTimer = nil
        }
    }
    
    // MARK: - Extract Time from API Response
    /// API javobidan vaqtni ajratib oladi ("05:30 (UTC)" -> "05:30")
    static func extractTime(_ value: String) -> String {
        return value.components(separatedBy: " ").first ?? value
    }
}

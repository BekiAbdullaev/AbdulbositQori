//
//  HapticFeedbackManager.swift
//  Abdulbosit Qori
//
//  Created by Assistant on 3/2/26.
//

import UIKit

class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    
    // MARK: - Long Vibration Properties
    private var isLongVibrationActive = false
    private var longVibrationTimer: Timer?
    
    private init() {}
    
    // MARK: - Prayer Time Specific Vibrations
    func triggerPrayerTimeVibration(for prayerType: PrayerType) {
        guard isVibrationEnabled() else { return }
        
        switch prayerType {
        case .bomdod:
            executeGentlePattern()
        case .quyosh:
            executeSinglePulse(.medium)
        case .peshin, .asr:
            executeStandardPattern()
        case .shom:
            executeDistinctivePattern()
        case .xufton:
            executeCalmPattern()
        }
    }
    
    // MARK: - General Haptic Feedback
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    // MARK: - Private Pattern Methods
    private func executeGentlePattern() {
        let light = UIImpactFeedbackGenerator(style: .light)
        light.prepare()
        
        DispatchQueue.main.async {
            light.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                light.impactOccurred()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                light.impactOccurred()
            }
        }
    }
    
    private func executeSinglePulse(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func executeStandardPattern() {
        let medium = UIImpactFeedbackGenerator(style: .medium)
        let notification = UINotificationFeedbackGenerator()
        
        medium.prepare()
        notification.prepare()
        
        DispatchQueue.main.async {
            notification.notificationOccurred(.warning)
            
            for i in 0..<2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.4 + 0.5) {
                    medium.impactOccurred()
                }
            }
        }
    }
    
    private func executeDistinctivePattern() {
        let heavy = UIImpactFeedbackGenerator(style: .heavy)
        let medium = UIImpactFeedbackGenerator(style: .medium)
        
        heavy.prepare()
        medium.prepare()
        
        DispatchQueue.main.async {
            heavy.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                medium.impactOccurred()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                medium.impactOccurred()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                heavy.impactOccurred()
            }
        }
    }
    
    private func executeCalmPattern() {
        let light = UIImpactFeedbackGenerator(style: .light)
        let notification = UINotificationFeedbackGenerator()
        
        light.prepare()
        notification.prepare()
        
        DispatchQueue.main.async {
            for i in 0..<4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                    light.impactOccurred()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                notification.notificationOccurred(.success)
            }
        }
    }
    
    // MARK: - Long Vibration Control
    func stopLongVibration() {
        isLongVibrationActive = false
        longVibrationTimer?.invalidate()
        longVibrationTimer = nil
        print("Stopped long vibration")
    }
    
    func triggerLongPrayerVibration(duration: TimeInterval = 30) {
        startPhoneCallLikeVibration(duration: duration)
    }
    
    // MARK: - Helper Methods
    private func isVibrationEnabled() -> Bool {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return false }
        
        return PrayerType.allCases.contains { prayer in
            let soundValue = UserDefaults.standard.string(forKey: "sound\(prayer.rawValue)") ?? "0"
            let state = PrayerTimeState(rawValue: Int(soundValue) ?? 0) ?? .cilent
            return state == .vibration
        }
    }
}

// MARK: - Convenience Extensions
extension HapticFeedbackManager {
    
    func prayerTimeAlert() {
        notification(type: .warning)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.impact(style: .heavy)
        }
    }
    
    func buttonTap() {
        selection()
    }
    
    func errorFeedback() {
        notification(type: .error)
    }
    
    func successFeedback() {
        notification(type: .success)
    }
    
    func customPrayerPattern(pulses: Int, interval: TimeInterval, intensity: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: intensity)
        generator.prepare()
        
        for i in 0..<pulses {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * interval) {
                generator.impactOccurred()
            }
        }
    }
    
    // MARK: - Phone Call-Like Vibration (Very Strong)
    func startPhoneCallLikeVibration(duration: TimeInterval = 30) {
        stopLongVibration()
        
        isLongVibrationActive = true
        let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        heavyGenerator.prepare()
        
        // Phone call pattern: Strong continuous vibration with short pauses
        var currentTime: TimeInterval = 0
        let vibrationDuration: TimeInterval = 1.0  // 1 second vibration
        let pauseDuration: TimeInterval = 0.3      // 0.3 second pause
        let cycleTime = vibrationDuration + pauseDuration
        
        // Start immediately with strong vibration
        triggerIntenseVibrationBurst()
        
        longVibrationTimer = Timer.scheduledTimer(withTimeInterval: cycleTime, repeats: true) { _ in
            guard self.isLongVibrationActive && currentTime < duration else {
                self.stopLongVibration()
                return
            }
            
            // Trigger intense vibration burst every cycle
            self.triggerIntenseVibrationBurst()
            currentTime += cycleTime
        }
        
        print("Started phone call-like vibration for \(duration) seconds")
    }
    
    private func triggerIntenseVibrationBurst() {
        let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        heavyGenerator.prepare()
        
        // Create rapid fire heavy vibrations to simulate phone call
        for i in 0..<8 {  // 8 rapid vibrations in 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.125) {
                heavyGenerator.impactOccurred()
            }
        }
    }
    
    // MARK: - Extreme Vibration (Maximum Intensity)
    func startExtremeVibration(duration: TimeInterval = 30) {
        stopLongVibration()
        
        isLongVibrationActive = true
        let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        let notificationGenerator = UINotificationFeedbackGenerator()
        
        heavyGenerator.prepare()
        notificationGenerator.prepare()
        
        var currentTime: TimeInterval = 0
        let interval: TimeInterval = 0.1  // Very fast - every 0.1 seconds
        
        longVibrationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            guard self.isLongVibrationActive && currentTime < duration else {
                self.stopLongVibration()
                return
            }
            
            // Alternate between heavy impact and notification
            if Int(currentTime * 10) % 3 == 0 {
                notificationGenerator.notificationOccurred(.error)
            } else {
                heavyGenerator.impactOccurred()
            }
            
            currentTime += interval
        }
        
        print("Started EXTREME vibration for \(duration) seconds - VERY INTENSE!")
    }
    
    // MARK: - Continuous Strong Vibration (No Pause)
    func startContinuousStrongVibration(duration: TimeInterval = 30) {
        stopLongVibration()
        
        isLongVibrationActive = true
        let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        heavyGenerator.prepare()
        
        var currentTime: TimeInterval = 0
        let interval: TimeInterval = 0.05  // Very rapid - every 0.05 seconds (20 times per second)
        
        longVibrationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            guard self.isLongVibrationActive && currentTime < duration else {
                self.stopLongVibration()
                return
            }
            
            heavyGenerator.impactOccurred()
            currentTime += interval
        }
        
        print("Started CONTINUOUS strong vibration for \(duration) seconds - NO PAUSE!")
    }
}

//
//  HapticFeedbackManager.swift
//  Abdulbosit Qori
//
//  Created by Assistant on 3/2/26.
//

import UIKit

class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    
    private init() {}
    
    // MARK: - Prayer Time Specific Vibrations
    func triggerPrayerTimeVibration(for prayerType: PrayerType) {
        guard isVibrationEnabled() else { return }
        
        // Different vibration patterns for different prayers
        switch prayerType {
        case .bomdod:
            // Gentle pattern for Fajr
            executeGentlePattern()
        case .quyosh:
            // Single pulse for Sunrise
            executeSinglePulse(.medium)
        case .peshin, .asr:
            // Standard pattern for midday prayers
            executeStandardPattern()
        case .shom:
            // Distinctive pattern for Maghrib
            executeDistinctivePattern()
        case .xufton:
            // Calm pattern for Isha
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
    
    // MARK: - Helper Methods
    private func isVibrationEnabled() -> Bool {
        // Check if device supports haptic feedback
        guard UIDevice.current.userInterfaceIdiom == .phone else { return false }
        
        // Check if any prayer has vibration enabled
        return PrayerType.allCases.contains { prayer in
            let soundValue = UserDefaults.standard.string(forKey: "sound\(prayer.rawValue)") ?? "0"
            let state = PrayerTimeState(rawValue: Int(soundValue) ?? 0) ?? .cilent
            return state == .vibration
        }
    }
}

// MARK: - Convenience Extensions
extension HapticFeedbackManager {
    
    // Quick access methods for common scenarios
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
}
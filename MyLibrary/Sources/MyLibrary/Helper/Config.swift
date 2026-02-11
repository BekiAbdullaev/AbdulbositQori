//
//  File.swift
//  
//
//  Created by Bekzod Abdullaev on 3/3/23.
//

import Foundation
import UIKit
import LocalAuthentication

public enum BiometricType {
    case none
    case touch
    case face
}


public struct Configs {
    
    public init() {
    }
    public static let version: Double = 1.0
    
    public func convertToLatin(name:String) -> String {
        
        var lastName = ""
        let splitedItems = name.split(separator: " ")        
        if splitedItems.count >= 2 {
            switch splitedItems[1].lowercased() {
            case "муҳаррам":
                lastName = splitedItems[0] + " Muharram"
            case "сафар":
                lastName = splitedItems[0] + " Safar"
            case "рабиъул":
                lastName = splitedItems[0] + " Rabiul avval"
            case "рабиъуссони":
                lastName = splitedItems[0] + " Rabius soniy"
            case "жумадул аввал":
                lastName = splitedItems[0] + " Jumodul avval"
            case "жумадиссони":
                lastName = splitedItems[0] + " Jumodus soniy"
            case "ражаб":
                lastName = splitedItems[0] + " Rajab"
            case "шаъбон":
                lastName = splitedItems[0] + " Sha'bon"
            case "рамазон":
                lastName = splitedItems[0] + " Ramazon"
            case "шаввол":
                lastName = splitedItems[0] + " Shavvol"
            case "зулқаъда":
                lastName = splitedItems[0] + " Zulqa'da"
            case "зулҳижжа":
                lastName = splitedItems[0] + " Zulhijja"
            default:
                lastName = name
            }
        } else {
            lastName = name
        }
        return lastName
    }
    
    // Calculate Progress Index
    public func getProgressAnimatedIndex()->Int{
        let bomdod = MainBean.shared.bomdodTime
        let quyosh = MainBean.shared.quyoshTime
        let peshin = MainBean.shared.peshinTime
        let asr = MainBean.shared.asrTime
        let shom =  MainBean.shared.shomTime
        let xufton = MainBean.shared.xuftonTime
        let currentTime = getCurrentTime()
            
        if checkIfCurrentTimeIsBetween(startTime: bomdod, endTime: quyosh) {
            let allTime = timeDifference(start: bomdod, end: quyosh)
            let remindTime = timeDifference(start: currentTime, end: quyosh)
            let percent = (allTime-remindTime)/allTime
            return checkByPercent(percent: percent)
        } else if checkIfCurrentTimeIsBetween(startTime: quyosh, endTime: peshin) {
            let allTime = timeDifference(start: quyosh, end: peshin)
            let remindTime = timeDifference(start: currentTime, end: peshin)
            let percent = (allTime-remindTime)/allTime
            return checkByPercent(percent: percent)
        } else if checkIfCurrentTimeIsBetween(startTime: peshin, endTime: asr) {
            let allTime = timeDifference(start: peshin, end: asr)
            let remindTime = timeDifference(start: currentTime, end: asr)
            let percent = (allTime-remindTime)/allTime
            return checkByPercent(percent: percent)
        } else if checkIfCurrentTimeIsBetween(startTime: asr, endTime: shom) {
            let allTime = timeDifference(start: asr, end: shom)
            let remindTime = timeDifference(start: currentTime, end: shom)
            let percent = (allTime-remindTime)/allTime
            return checkByPercent(percent: percent)
        } else if checkIfCurrentTimeIsBetween(startTime: shom, endTime: xufton) {
            let allTime = timeDifference(start: shom, end: xufton)
            let remindTime = timeDifference(start: currentTime, end: xufton)
            let percent = (allTime-remindTime)/allTime
            return checkByPercent(percent: percent)
        }  else if checkIfCurrentTimeIsBetween(startTime:"00:01", endTime: bomdod) {
            let allTime = timeDifference(start: "00:01", end: bomdod)
            let remindTime = timeDifference(start: currentTime, end: bomdod)
            let percent = (allTime-remindTime)/allTime
            return checkByPercent(percent: percent)
        }
        return 1
    }
    
    func timeDifference(start:String, end:String) -> Double{
        
        guard let start = today.date(from: start),
            let end = today.date(from: end) else {
            return 0.0
        }
        let elapsedTime = end.timeIntervalSince(start)
        let hours = floor(elapsedTime / 60 / 60)
        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        return minutes + (hours*60)
    }
    
    func checkIfCurrentTimeIsBetween(startTime: String, endTime: String) -> Bool {
        guard let start = today.date(from: startTime),
              let end = today.date(from: endTime) else {
            return false
        }
        return DateInterval(start: start, end: end).contains(Date())
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
    
    func checkByPercent(percent:Double)-> Int {
        if percent>=0 && percent<0.05 {
            return 0
        } else if percent>=0.05 && percent<0.1 {
            return 1
        } else if percent>=0.1 && percent<0.15 {
            return 2
        } else if percent>=0.15 && percent<0.2 {
            return 3
        } else if percent>=0.2 && percent<0.25 {
            return 4
        } else if percent>=0.25 && percent<0.3 {
            return 5
        } else if percent>=0.3 && percent<0.35 {
            return 6
        } else if percent>=0.35 && percent<0.4 {
            return 7
        } else if percent>=0.4 && percent<0.45 {
            return 8
        } else if percent>=0.45 && percent<0.5 {
            return 9
        } else if percent>=0.5 && percent<0.55 {
            return 10
        } else if percent>=0.55 && percent<0.6 {
            return 11
        } else if percent>=0.6 && percent<0.65 {
            return 12
        } else if percent>=0.65 && percent<0.7 {
            return 13
        } else if percent>=0.7 && percent<0.75 {
            return 14
        } else if percent>=0.75 && percent<0.8 {
            return 15
        } else if percent>=0.8 && percent<0.85 {
            return 16
        } else if percent>=0.85 && percent<0.9 {
            return 17
        } else if percent>=0.9 && percent<0.95 {
            return 18
        } else if percent>=0.95 && percent<1.0 {
            return 19
        }
        return 1
    }
    
    let today: DateFormatter = {
        let d = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "uz_Latn_UZ")
        dateFormatter.defaultDate = Calendar.current.startOfDay(for: Date())
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
        
    }()
    
    public func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .touchID:
                return .touch
            case .faceID:
                return .face
            default:
                return .none
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    public func chekMakOrMad(placeType:String) -> String{
        switch placeType {
        case "mak-mad":
            return ""
        case "mad","mad\n":
            return "madaniy, "
        case "mak","mak\n":
            return "makkiy, "
        default:
            return ""
        }
    }
}

public struct DefaultEmptyResponse: Codable {
    public let statusCode: Int?
    public let message: String?
    public let version: String?
}

public struct PrayerAudioModel {
    public let value:Float
    public let index:Int
    public init(value: Float, index: Int) {
        self.value = value
        self.index = index
    }
}




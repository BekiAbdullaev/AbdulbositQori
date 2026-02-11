//
//  File.swift
//  
//
//  Created by Bekzod Abdullaev on 3/3/23.
//

import UIKit

// MARK: - Namaz Times
public struct NamazTimesRequest:Codable{
    public let day: String
    public let lan: String
    public let lat: String
    public let timezone: String

    public init(day:String, lan:String, lat:String ,timezone:String){
        self.day = day
        self.lan = lan
        self.lat = lat
        self.timezone = timezone
    }
}

public struct NamazTimeResponse:Codable {
    public let prayertimes: [Prayertime]
}


public struct Prayertime: Codable {
    public let hijri, bomdod, quyosh, peshin: String?
    public let asr, shom, xufton, zuho: String?
    public let tahajjud: String?
    
    public init(hijri: String?, bomdod: String?, quyosh: String?, peshin: String?, asr: String?, shom: String?, xufton: String?, zuho: String?, tahajjud: String?) {
        self.hijri = hijri
        self.bomdod = bomdod
        self.quyosh = quyosh
        self.peshin = peshin
        self.asr = asr
        self.shom = shom
        self.xufton = xufton
        self.zuho = zuho
        self.tahajjud = tahajjud
    }
}

// MARK: - CityNames
public struct CityResponse:Codable {
    public let regions: [Regions]
}
public struct Regions: Codable {
    public let id: Int?
    public let name, lat, lan: String?
    public init(id: Int?, name: String?, lat: String?, lan: String?) {
        self.id = id
        self.name = name
        self.lat = lat
        self.lan = lan
    }
}

// MARK: - MediaMP3Files
public struct MediasResponse:Codable {
    public let quran_surahs: [MediasFiles]
    //public let prayer_tutorials: [MediasFiles]
    public let video_tutorials:[MediasFiles]
    public let tasbehs:[MediasFiles]
}


public struct MediasFiles: Codable {
    public let id,verses_count: Int?
    public let name, file_name, file_url, duration, pdf_url, place_type: String?
    
    public init(id: Int?, verses_count: Int?, name: String?, file_name: String?, file_url: String?, duration: String?, pdf_url: String?, place_type: String?) {
        self.id = id
        self.verses_count = verses_count
        self.name = name
        self.file_name = file_name
        self.file_url = file_url
        self.duration = duration
        self.pdf_url = pdf_url
        self.place_type = place_type
    }
}


// MARK: - NamazsFiles
public struct NamazsResponse:Codable {
    public let namaz_files: [NamazFiles]
    
}
public struct NamazFiles: Codable {
    public let id: Int?
    public let name, key, file_url, duration: String?
}



public struct NamazTimeInfos {
    public let dayName:String?
    public let bomdodTime:String?
    public let quyoshTime:String?
    public let peshinTime:String?
    public let asrTime:String?
    public let shomTime:String?
    public let xuftonTime:String?
    public let nextDayBomdodTime:String?
    public let day:String?
    
    public init(dayName: String?, bomdodTime: String?, quyoshTime: String?, peshinTime: String?, asrTime: String?, shomTime: String?, xuftonTime: String?, nextDayBomdodTime: String?, day:String?) {
        self.dayName = dayName
        self.bomdodTime = bomdodTime
        self.quyoshTime = quyoshTime
        self.peshinTime = peshinTime
        self.asrTime = asrTime
        self.shomTime = shomTime
        self.xuftonTime = xuftonTime
        self.nextDayBomdodTime = nextDayBomdodTime
        self.day = day
    }
}

public struct NamazPeriodRequest: Codable {
    public let startDate, endDate, lan, lat, timezone: String

    public init(startDate: String, endDate: String, lan: String, lat: String, timezone: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.lan = lan
        self.lat = lat
        self.timezone = timezone
    }
    
    public enum CodingKeys: String, CodingKey {
        case startDate = "from_date"
        case endDate = "to_date"
        case lan, lat, timezone
    }
}


public struct NamazPeriodResponse: Codable {
    public let code: Int
    public let status: String
    public let data: [Datum]
}

public struct Datum: Codable {
    public let timings: Timings
    public let date: DateInfo
    public let meta: Meta
}

public struct Timings: Codable {
    public let fajr, sunrise, dhuhr, asr: String
    public let sunset, maghrib, isha, imsak: String
    public let midnight, firstthird, lastthird: String

    public enum CodingKeys: String, CodingKey {
        case fajr = "Fajr"
        case sunrise = "Sunrise"
        case dhuhr = "Dhuhr"
        case asr = "Asr"
        case sunset = "Sunset"
        case maghrib = "Maghrib"
        case isha = "Isha"
        case imsak = "Imsak"
        case midnight = "Midnight"
        case firstthird = "Firstthird"
        case lastthird = "Lastthird"
    }
}

public struct DateInfo: Codable {
    public let readable: String
    public let timestamp: String
    public let gregorian: Gregorian
    public let hijri: Hijri
}

public struct Gregorian: Codable {
    public let date: String
    public let format: String
    public let day: String
    public let weekday: Weekday
    public let month: Month
    public let year: String
}

public struct Hijri: Codable {
    public let date: String
    public let format: String
    public let day: String
    public let weekday: Weekday
    public let month: HijriMonth
    public let year: String
    public let holidays: [String]
}

public struct Weekday: Codable {
    public let en: String
    public let ar: String?
}

public struct Month: Codable {
    public let number: Int
    public let en: String
}

public struct HijriMonth: Codable {
    public let number: Int
    public let en: String
    public let ar: String
    public let days: Int
}

public struct Meta: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let method: Method
}

struct Method: Codable {
    let id: Int
    let name: String
    let params: MethodParams
}

struct MethodParams: Codable {
    let fajr: Int
    let isha: Int

    enum CodingKeys: String, CodingKey {
        case fajr = "Fajr"
        case isha = "Isha"
    }
}


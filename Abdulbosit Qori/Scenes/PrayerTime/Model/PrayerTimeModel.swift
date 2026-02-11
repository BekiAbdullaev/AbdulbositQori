//
//  PrayerTimeModel.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/5/23.
//

import Foundation

struct PrayerTimeModel {
    let prayerList = [PrayerTimeInnerModel(name: "Bomdod", state: .silent),
             PrayerTimeInnerModel(name: "Quyosh", state: .silent),
             PrayerTimeInnerModel(name: "Peshin", state: .silent),
             PrayerTimeInnerModel(name: "Asr", state: .silent),
             PrayerTimeInnerModel(name: "Shom", state: .silent),
             PrayerTimeInnerModel(name: "Xufton", state: .silent)]
    var prayerSoundsList = [PrayerSoundControlModel(image: "ic_mute", name: "Eslatmasin", needPlay: false),
                            PrayerSoundControlModel(image: "ic_vibration", name: "Tovushsiz eslatsin", needPlay: false),
                            PrayerSoundControlModel(image: "ic_max_volume", name: "Azon", needPlay: true)]
}

struct PrayerTimeInnerModel {
    var name:String
    var state:PrayerTimeState
}

struct PrayerSoundControlModel{
    var image:String
    var name:String
    var needPlay:Bool
}

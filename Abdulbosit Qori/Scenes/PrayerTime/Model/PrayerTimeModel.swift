//
//  PrayerTimeModel.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/5/23.
//

import Foundation

struct PrayerTimeModel {
    let prayerList = [PrayerTimeInnerModel(name: "Bomdod", state: .cilent),
             PrayerTimeInnerModel(name: "Quyosh", state: .cilent),
             PrayerTimeInnerModel(name: "Peshin", state: .cilent),
             PrayerTimeInnerModel(name: "Asr", state: .cilent),
             PrayerTimeInnerModel(name: "Shom", state: .cilent),
             PrayerTimeInnerModel(name: "Xufton", state: .cilent)]
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

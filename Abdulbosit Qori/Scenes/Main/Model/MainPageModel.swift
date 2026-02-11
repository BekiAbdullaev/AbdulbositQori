//
//  MainPageModel.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/3/23.
//

import UIKit

enum MainPageItemType {
    case quran
    case quranStudy
    case payerOrder
    case qibla
    case prayerTime
    case rosary
}

struct MainPageItems {
    let title:String
    let image:String
    let type:MainPageItemType
}

struct MainPageModel {
    let listMainItems = [MainPageItems(title: "Qur'on", image: "ic_item_0", type: .quran),
                         MainPageItems(title: "Qur'on ta'limi", image: "ic_item_1", type: .quranStudy),
                         MainPageItems(title: "Namoz o'qish tartibi", image: "ic_item_2", type: .payerOrder),
                         MainPageItems(title: "Qibla", image: "ic_item_3", type: .qibla),
                         MainPageItems(title: "Namoz vaqtlari", image: "ic_item_4", type: .prayerTime),
                         MainPageItems(title: "Tasbeh", image: "ic_item_5", type: .rosary)]
}

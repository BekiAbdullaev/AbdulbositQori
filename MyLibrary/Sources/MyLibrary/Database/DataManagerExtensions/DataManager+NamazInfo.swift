//
//  File.swift
//  MyLibrary
//
//  Created by Abdullaev Bekzod on 25/01/25.
//

import Foundation
import CoreData

// CRUD operations for LocalHistory
extension DataManager {
    
    public func insertNamazInfo(namazInfos:[NamazTimeInfos]) {
        for namazInfo in namazInfos {
            insertNamazInfo(info: namazInfo)
        }
    }
    
    public func insertNamazInfo(info:NamazTimeInfos) {
        let data = NamazInfoCD(context: context)
        data.dayName = info.dayName
        data.bomdodTime = info.bomdodTime
        data.quyoshTime = info.quyoshTime
        data.peshinTime = info.peshinTime
        data.asrTime = info.asrTime
        data.shomTime = info.shomTime
        data.xuftonTime = info.xuftonTime
        data.nextDayBomdodTime = info.nextDayBomdodTime
        data.day = info.day
        save()
    }
    
    
//    public func fetchNamazDayInfo(day:String, completion: @escaping ([NamazTimeInfos]) -> Void) {
//        let fetchRequest: NSFetchRequest<NamazInfoCD> = NamazInfoCD.fetchRequest()
//        let predicate = NSPredicate(format: "day == %@", day)
//        fetchRequest.predicate = predicate
//        
//        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asyncFetchResult in
//            guard let namazInfos = asyncFetchResult.finalResult else {
//                completion([])
//                return
//            }
//            
//            let namazInfoArr = namazInfos.map { info in
//                NamazTimeInfos(
//                    dayName: info.dayName,
//                    bomdodTime: info.bomdodTime,
//                    quyoshTime: info.quyoshTime,
//                    peshinTime: info.peshinTime,
//                    asrTime: info.asrTime,
//                    shomTime: info.shomTime,
//                    xuftonTime: info.xuftonTime,
//                    nextDayBomdodTime: info.nextDayBomdodTime,
//                    day: info.day
//                )
//            }
//            completion(namazInfoArr)
//        }
//        do {
//            try context.execute(asyncFetchRequest)
//        } catch {
//            print("Error fetching branches asynchronously: \(error)")
//            completion([])
//        }
//    }
    
    
    public func fetchNamazDayInfo(day: String) -> [NamazTimeInfos] {
        let namazInfos = fetchAllNamazInfoCD()
        var namazInfosArr: [NamazTimeInfos] = []
        for namazInfo in namazInfos {
            if namazInfo.day == day {
                let info = NamazTimeInfos(
                    dayName: namazInfo.dayName,
                    bomdodTime: namazInfo.bomdodTime,
                    quyoshTime: namazInfo.quyoshTime,
                    peshinTime: namazInfo.peshinTime,
                    asrTime: namazInfo.asrTime,
                    shomTime: namazInfo.shomTime,
                    xuftonTime: namazInfo.xuftonTime,
                    nextDayBomdodTime: namazInfo.nextDayBomdodTime,
                    day: namazInfo.day)
            
                namazInfosArr.append(info)
            }
        }
        return namazInfosArr
    }

    
    public func fetchAllNamazInfoCD() -> [NamazInfoCD] {
        var details: [NamazInfoCD] = []
        let fetchRequest:NSFetchRequest<NamazInfoCD> = NamazInfoCD.fetchRequest()
        do {
            details = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching Services: \(error)")
        }
        return details
    }
    
    
    public func deleteNamazInfo(namazDay: String){
        let namazDays = fetchAllNamazInfoCD()
        for day in namazDays {
            if day.day == namazDay {
                context.delete(day)
            }
        }
        save()
    }
}

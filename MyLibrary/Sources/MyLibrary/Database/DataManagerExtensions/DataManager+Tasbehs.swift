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
    
    public func insertTasbehs(tasbehs:[MediasFiles]) {
        for tasbeh in tasbehs {
            insertTasbeh(tasbeh:tasbeh)
        }
    }
    
    public func insertTasbeh(tasbeh:MediasFiles) {
        let data = Tasbehs(context: context)
        data.id = Int16(tasbeh.id ?? 0)
        data.name = tasbeh.name ?? ""
        data.file_name = tasbeh.file_name ?? ""
        data.file_url = tasbeh.file_url ?? ""
        data.duration = tasbeh.duration ?? ""
        data.verses_count = Int16(tasbeh.verses_count ?? 0)
        data.pdf_url = tasbeh.pdf_url ?? ""
        data.place_type = tasbeh.place_type ?? ""
        save()
    }
    
    public func fetchAllTasbehs() -> [MediasFiles] {
        selectAllTasbehs(tasbehs: fetchAllTasbehsCD())
    }
    
    
    public func selectAllTasbehs(tasbehs:[Tasbehs]) -> [MediasFiles] {
        var tasbehsArr = [MediasFiles]()
        for tasbeh in tasbehs {
            tasbehsArr.append(MediasFiles(
                id: Int(tasbeh.id),
                verses_count: Int(tasbeh.verses_count),
                name: tasbeh.name,
                file_name: tasbeh.file_name,
                file_url: tasbeh.file_url,
                duration: tasbeh.duration,
                pdf_url: tasbeh.pdf_url,
                place_type: tasbeh.place_type
            ))
        }
        return tasbehsArr
    }
    
    
    private func fetchAllTasbehsCD() -> [Tasbehs] {
        var details: [Tasbehs] = []
        let fetchRequest:NSFetchRequest<Tasbehs> = Tasbehs.fetchRequest()
        do {
            details = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching Services: \(error)")
        }
        return details
    }
    
    
    public func deleteTasbehs(tasbehID: Int) {
        let tasbehs = fetchAllTasbehsCD()
        for tasbeh in tasbehs {
            if tasbeh.id == tasbehID {
                context.delete(tasbeh)
            }
        }
        save()
    }
}

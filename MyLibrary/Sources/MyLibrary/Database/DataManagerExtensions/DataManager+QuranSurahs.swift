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
    
    public func insertQuranSurahs(surahs:[MediasFiles]) {
        for surah in surahs {
            insertSurah(surah: surah)
        }
    }
    
    public func insertSurah(surah:MediasFiles) {
        let data = QuranSurahs(context: context)
        data.id = Int16(surah.id ?? 0)
        data.name = surah.name ?? ""
        data.file_name = surah.file_name ?? ""
        data.file_url = surah.file_url ?? ""
        data.duration = surah.duration ?? ""
        data.verses_count = Int16(surah.verses_count ?? 0)
        data.pdf_url = surah.pdf_url ?? ""
        data.place_type = surah.place_type ?? ""
        save()
    }
    
    public func fetchAllQuranSurahs() -> [MediasFiles] {
        selectAllQuranSurahs(surahs: fetchAllQuranSurahsCD())
    }
    
    
    public func selectAllQuranSurahs(surahs:[QuranSurahs]) -> [MediasFiles] {
        var quranSurahs = [MediasFiles]()
        for surah in surahs {
            quranSurahs.append(MediasFiles(
                id: Int(surah.id),
                verses_count: Int(surah.verses_count),
                name: surah.name,
                file_name: surah.file_name,
                file_url: surah.file_url,
                duration: surah.duration,
                pdf_url: surah.pdf_url,
                place_type: surah.place_type
            ))
        }
        return quranSurahs
    }
    
    
    private func fetchAllQuranSurahsCD() -> [QuranSurahs] {
        var details: [QuranSurahs] = []
        let fetchRequest:NSFetchRequest<QuranSurahs> = QuranSurahs.fetchRequest()
        do {
            details = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching Services: \(error)")
        }
        return details
    }
    
    
    public func deleteQuranSurahs(surahID: Int) {
        let surahs = fetchAllQuranSurahsCD()
        for surah in surahs {
            if surah.id == surahID {
                context.delete(surah)
            }
        }
        save()
    }
}

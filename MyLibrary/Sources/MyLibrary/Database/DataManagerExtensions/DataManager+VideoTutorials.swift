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
    
    public func insertVideos(videos:[MediasFiles]) {
        for video in videos {
            insertVideo(video: video)
        }
    }
    
    public func insertVideo(video:MediasFiles) {
        let data = VideoTutorials(context: context)
        data.id = Int16(video.id ?? 0)
        data.name = video.name ?? ""
        data.file_name = video.file_name ?? ""
        data.file_url = video.file_url ?? ""
        data.duration = video.duration ?? ""
        data.verses_count = Int16(video.verses_count ?? 0)
        data.pdf_url = video.pdf_url ?? ""
        data.place_type = video.place_type ?? ""
        save()
    }
    
    public func fetchAllVideos() -> [MediasFiles] {
        selectAllVideos(videos: fetchAllVideosCD())
    }
    
    
    public func selectAllVideos(videos:[VideoTutorials]) -> [MediasFiles] {
        var videosArr = [MediasFiles]()
        for video in videos {
            videosArr.append(MediasFiles(
                id: Int(video.id),
                verses_count: Int(video.verses_count),
                name: video.name,
                file_name: video.file_name,
                file_url: video.file_url,
                duration: video.duration,
                pdf_url: video.pdf_url,
                place_type: video.place_type
            ))
        }
        return videosArr
    }
    
    
    private func fetchAllVideosCD() -> [VideoTutorials] {
        var details: [VideoTutorials] = []
        let fetchRequest:NSFetchRequest<VideoTutorials> = VideoTutorials.fetchRequest()
        do {
            details = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching Services: \(error)")
        }
        return details
    }
    
    
    public func deleteQuranSurahs(videoID: Int) {
        let videos = fetchAllVideosCD()
        for video in videos {
            if video.id == videoID {
                context.delete(video)
            }
        }
        save()
    }
}

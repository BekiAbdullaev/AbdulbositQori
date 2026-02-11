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
    
    public func insertRegions(regions:[Regions]) {
        for region in regions {
            insertRegion(region: region)
        }
    }
    
    public func insertRegion(region:Regions) {
        let data = RegionsCD(context: context)
        data.id = Int16(region.id ?? 0)
        data.name = region.name ?? ""
        data.lan = region.lan ?? ""
        data.lat = region.lat ?? ""
        save()
    }
    
    public func fetchAllRegions() -> [Regions] {
        selectAllRegions(regions: fetchAllRegionsCD())
    }
    
    
    public func selectAllRegions(regions:[RegionsCD]) -> [Regions] {
        var regionsArr = [Regions]()
        for region in regions {
            
            regionsArr.append(Regions(
                id: Int(region.id),
                name: region.name,
                lat: region.lat,
                lan: region.lan
            ))
        }
        return regionsArr
    }
    
    
    private func fetchAllRegionsCD() -> [RegionsCD] {
        var details: [RegionsCD] = []
        let fetchRequest:NSFetchRequest<RegionsCD> = RegionsCD.fetchRequest()
        do {
            details = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching Services: \(error)")
        }
        return details
    }
    
    
    public func deleteRegion(regionID: Int) {
        let regions = fetchAllRegionsCD()
        for region in regions {
            if region.id == regionID {
                context.delete(region)
            }
        }
        save()
    }
}

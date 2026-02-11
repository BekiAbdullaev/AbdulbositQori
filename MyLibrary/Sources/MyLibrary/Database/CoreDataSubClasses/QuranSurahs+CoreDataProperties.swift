//
//  QuranSurahs+CoreDataProperties.swift
//  
//
//  Created by Abdullaev Bekzod on 25/01/25.
//
//

import Foundation
import CoreData


extension QuranSurahs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuranSurahs> {
        return NSFetchRequest<QuranSurahs>(entityName: "QuranSurahs")
    }

    @NSManaged public var duration: String?
    @NSManaged public var file_name: String?
    @NSManaged public var file_url: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var pdf_url: String?
    @NSManaged public var place_type: String?
    @NSManaged public var verses_count: Int16

}

//
//  Tasbehs+CoreDataProperties.swift
//  
//
//  Created by Abdullaev Bekzod on 25/01/25.
//
//

import Foundation
import CoreData


extension Tasbehs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasbehs> {
        return NSFetchRequest<Tasbehs>(entityName: "Tasbehs")
    }

    @NSManaged public var place_type: String?
    @NSManaged public var pdf_url: String?
    @NSManaged public var verses_count: Int16
    @NSManaged public var duration: String?
    @NSManaged public var file_url: String?
    @NSManaged public var file_name: String?
    @NSManaged public var name: String?
    @NSManaged public var id: Int16

}

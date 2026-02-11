//
//  NamazInfoCD+CoreDataProperties.swift
//  
//
//  Created by Abdullaev Bekzod on 25/01/25.
//
//

import Foundation
import CoreData


extension NamazInfoCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NamazInfoCD> {
        return NSFetchRequest<NamazInfoCD>(entityName: "NamazInfoCD")
    }

    @NSManaged public var dayName: String?
    @NSManaged public var bomdodTime: String?
    @NSManaged public var quyoshTime: String?
    @NSManaged public var peshinTime: String?
    @NSManaged public var asrTime: String?
    @NSManaged public var shomTime: String?
    @NSManaged public var xuftonTime: String?
    @NSManaged public var nextDayBomdodTime: String?
    @NSManaged public var day: String?

}

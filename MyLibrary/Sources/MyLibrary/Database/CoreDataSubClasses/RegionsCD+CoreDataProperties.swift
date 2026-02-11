//
//  RegionsCD+CoreDataProperties.swift
//  
//
//  Created by Abdullaev Bekzod on 25/01/25.
//
//

import Foundation
import CoreData


extension RegionsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RegionsCD> {
        return NSFetchRequest<RegionsCD>(entityName: "RegionsCD")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var lat: String?
    @NSManaged public var lan: String?

}

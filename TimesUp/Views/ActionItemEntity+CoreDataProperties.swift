//
//  ActionItemEntity+CoreDataProperties.swift
//  
//
//  Created by Jian Cheng on 2024/7/13.
//
//

import Foundation
import CoreData


extension ActionItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActionItemEntity> {
        return NSFetchRequest<ActionItemEntity>(entityName: "ActionItemEntity")
    }

    @NSManaged public var mainTitle: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var link: String?
    
    extension ActionItemEntity : Identifiable {

    }

}

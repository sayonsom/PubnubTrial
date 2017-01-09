//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Sayonsom Chanda on 1/8/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task");
    }

    @NSManaged public var dueDate: NSDate?
    @NSManaged public var isErrand: Bool
    @NSManaged public var isFamily: Bool
    @NSManaged public var isFun: Bool
    @NSManaged public var isImportant: Bool
    @NSManaged public var isSecret: Bool
    @NSManaged public var isSocial: Bool
    @NSManaged public var mood: String?
    @NSManaged public var name: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var taskLocation: NSObject?

}

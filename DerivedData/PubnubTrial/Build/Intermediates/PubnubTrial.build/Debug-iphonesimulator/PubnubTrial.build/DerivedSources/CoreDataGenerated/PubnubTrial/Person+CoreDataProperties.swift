//
//  Person+CoreDataProperties.swift
//  
//
//  Created by Sayonsom Chanda on 1/8/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var anniversary: NSDate?
    @NSManaged public var birthday: NSDate?
    @NSManaged public var homeaddress: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var photo: NSObject?
    @NSManaged public var workaddress: NSObject?

}

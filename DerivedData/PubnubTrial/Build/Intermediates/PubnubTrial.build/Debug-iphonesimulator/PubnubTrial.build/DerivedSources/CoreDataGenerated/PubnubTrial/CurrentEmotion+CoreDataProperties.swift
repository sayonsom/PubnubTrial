//
//  CurrentEmotion+CoreDataProperties.swift
//  
//
//  Created by Sayonsom Chanda on 1/8/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CurrentEmotion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentEmotion> {
        return NSFetchRequest<CurrentEmotion>(entityName: "CurrentEmotion");
    }

    @NSManaged public var awkward: Float
    @NSManaged public var excited: Float
    @NSManaged public var fatigued: Float
    @NSManaged public var indifferent: Float
    @NSManaged public var stressed: Float
    @NSManaged public var uneasy: Float

}

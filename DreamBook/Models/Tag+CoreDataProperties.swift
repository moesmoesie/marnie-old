//
//  Tag+CoreDataProperties.swift
//  DreamBook
//
//  Created by moesmoesie on 30/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var text: String?
    @NSManaged public var dreams: NSSet?
    
    var wrapperText : String {
        text ?? ""
    }

}

// MARK: Generated accessors for dreams
extension Tag {

    @objc(addDreamsObject:)
    @NSManaged public func addToDreams(_ value: Dream)

    @objc(removeDreamsObject:)
    @NSManaged public func removeFromDreams(_ value: Dream)

    @objc(addDreams:)
    @NSManaged public func addToDreams(_ values: NSSet)

    @objc(removeDreams:)
    @NSManaged public func removeFromDreams(_ values: NSSet)

}

//
//  Tag+CoreDataProperties.swift
//  DreamBook
//
//  Created by moesmoesie on 03/05/2020.
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
    @NSManaged public var dream: Dream?
    
    var wrapperText : String {
        text ?? ""
    }

}

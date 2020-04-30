//
//  Dream+CoreDataProperties.swift
//  DreamBook
//
//  Created by moesmoesie on 30/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//
//

import Foundation
import CoreData


extension Dream {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dream> {
        return NSFetchRequest<Dream>(entityName: "Dream")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isBookmarked: Bool
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    
    public var wrapperDateString : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if let date = date{
            return formatter.string(from: date)
        }
        return "Unknown date"
    }
    
    public var wrapperDate : Date {
        date ?? Date()
    }
    
    public var wrappedText : String {
        text ?? ""
    }
    
    public var wrappedTitle: String{
        title ?? "Unknown title"
    }
    
}

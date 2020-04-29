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

    @NSManaged public var date: Date
    @NSManaged public var id: UUID?
    @NSManaged public var isBookmarked: Bool
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    
    public var dateString : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self.date)
    }

}

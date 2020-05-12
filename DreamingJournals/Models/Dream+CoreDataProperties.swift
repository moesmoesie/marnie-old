//
//  Dream+CoreDataProperties.swift
//  DreamBook
//
//  Created by moesmoesie on 07/05/2020.
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
    @NSManaged public var tags: NSOrderedSet?
    
    var wrappedTags : [Tag]{
        var wrappedTags : [Tag] = []
        for tag in tags ?? []{
            let tempTag = tag as! Tag
            wrappedTags.append(tempTag)
        }
        return wrappedTags
    }
    
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

// MARK: Generated accessors for tags
extension Dream {

    @objc(insertObject:inTagsAtIndex:)
    @NSManaged public func insertIntoTags(_ value: Tag, at idx: Int)

    @objc(removeObjectFromTagsAtIndex:)
    @NSManaged public func removeFromTags(at idx: Int)

    @objc(insertTags:atIndexes:)
    @NSManaged public func insertIntoTags(_ values: [Tag], at indexes: NSIndexSet)

    @objc(removeTagsAtIndexes:)
    @NSManaged public func removeFromTags(at indexes: NSIndexSet)

    @objc(replaceObjectInTagsAtIndex:withObject:)
    @NSManaged public func replaceTags(at idx: Int, with value: Tag)

    @objc(replaceTagsAtIndexes:withTags:)
    @NSManaged public func replaceTags(at indexes: NSIndexSet, with values: [Tag])

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSOrderedSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSOrderedSet)

}

//
//  Tag+CoreDataClass.swift
//  DreamBook
//
//  Created by moesmoesie on 30/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Tag)
public class Tag: NSManagedObject {
    
    @nonobjc class func createTag(from tagViewModel : TagViewModel, context managedObjectContext : NSManagedObjectContext) -> Tag{
        let tag = Tag(entity: Tag.entity(), insertInto: managedObjectContext)
        tag.text = tagViewModel.text
        return tag
    }
    
    
    @nonobjc class func uniqueTagTextFetch() -> NSFetchRequest<NSDictionary>{
        let fetch : NSFetchRequest<NSDictionary> = NSFetchRequest<NSDictionary>(entityName: "Tag")
        fetch.sortDescriptors = []
        fetch.resultType = .dictionaryResultType
        fetch.propertiesToFetch = ["text"]
        fetch.returnsDistinctResults = true
        return fetch
    }
    
    
    @nonobjc class  func deleteDreamlessTags(context managedObjectContext: NSManagedObjectContext ){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        fetchRequest.predicate = NSPredicate(
            format: "dream == nil"
        )
        do{
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try managedObjectContext.execute(batchDeleteRequest)
        }catch{
            print("error fetching tags to delete")
        }
    }
}

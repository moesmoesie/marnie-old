//
//  Dream+CoreDataClass.swift
//  DreamBook
//
//  Created by moesmoesie on 30/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Dream)
public class Dream: NSManagedObject {
    @nonobjc class func customFetchRequest(filterViewModels : [FilterViewModel] = [], limit : Int? = nil) -> NSFetchRequest<Dream>{
        let fetch : NSFetchRequest<Dream> = NSFetchRequest<Dream>(entityName: "Dream")
        fetch.sortDescriptors = [NSSortDescriptor(keyPath: \Dream.date, ascending: false)]
        var predicates  : [NSPredicate] = []
        
        for filterViewModel in filterViewModels{
            predicates.append(filterViewModel.filter.getPredicate())
        }
        
        if let fetchLimit = limit{
            fetch.fetchLimit = fetchLimit
            fetch.fetchBatchSize = fetchLimit / 2
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetch.predicate = NSPredicate(format : compoundPredicate.predicateFormat)
        return fetch
    }
    
    @nonobjc class func getDream(from dreamViewModel : DreamViewModel, context : NSManagedObjectContext) -> Dream{
        let dream = Dream(entity: Dream.entity(), insertInto: context)
        dream.id = dreamViewModel.id
        dream.isBookmarked = dreamViewModel.isBookmarked
        dream.date = dreamViewModel.date
        dream.title = dreamViewModel.title
        dream.text = dreamViewModel.text
        dream.isNightmare = dreamViewModel.isNightmare
        dream.isLucid = dreamViewModel.isLucid
        
        for tagViewModel in dreamViewModel.tags {
            let tag = Tag(context: context)
            tag.text = tagViewModel.text
            dream.addToTags(tag)
        }
        
        return dream
    }
}

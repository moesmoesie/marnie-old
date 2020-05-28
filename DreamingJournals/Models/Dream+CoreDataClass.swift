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
    @nonobjc class func customFetchRequest(filterViewModels : [FilterViewModel] = []) -> NSFetchRequest<Dream>{
        let fetch : NSFetchRequest<Dream> = NSFetchRequest<Dream>(entityName: "Dream")
        fetch.sortDescriptors = [NSSortDescriptor(keyPath: \Dream.date, ascending: false)]
        var predicates  : [NSPredicate] = []
        
        for filterViewModel in filterViewModels{
            predicates.append(filterViewModel.filter.getPredicate())
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetch.predicate = NSPredicate(format : compoundPredicate.predicateFormat)
        return fetch
    }
}

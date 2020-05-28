//
//  DreamStore.swift
//  DreamingJournals
//
//  Created by moesmoesie on 28/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import CoreData

class DreamStore : ObservableObject{
    @Published var dreams : [DreamViewModel] = []

    let managedObjectContext : NSManagedObjectContext
    
    init(managedObjectContext : NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.loadDreams()
    }
    
    func loadDreams(filterViewModels : [FilterViewModel] = []){
        let fetch : NSFetchRequest<Dream> = Dream.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(keyPath: \Dream.date, ascending: false)]
        var predicates  : [NSPredicate] = []
        
        for filterViewModel in filterViewModels{
            predicates.append(filterViewModel.filter.getPredicate())
        }
        
        let compoundPredicate =  NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        fetch.predicate = NSPredicate(format: compoundPredicate.predicateFormat)
            if let fetchedDreams = try? self.managedObjectContext.fetch(fetch){
            self.dreams = fetchedDreams.map({DreamViewModel(dream: $0)})
        }
    }
}

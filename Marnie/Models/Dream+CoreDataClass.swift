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
    
    @nonobjc class func dreamCount(with filterViewModels : [FilterViewModel] = [],context managedObjectContext : NSManagedObjectContext) -> Int{
        let fetch  = NSFetchRequest<NSNumber>(entityName: "Dream")
        var predicates  : [NSPredicate] = []
        fetch.resultType = .countResultType
        
        for filterViewModel in filterViewModels{
            predicates.append(filterViewModel.filter.getPredicate())
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetch.predicate = NSPredicate(format : compoundPredicate.predicateFormat)
        
        do {
            let count = try managedObjectContext.fetch(fetch)
            return count.first!.intValue
        } catch {
            return 0
        }
    }
    
    
    
    
    @nonobjc class func fetchDream(id : UUID, context managedObjectContext: NSManagedObjectContext ) -> Dream?{
        let fetch : NSFetchRequest<Dream> = NSFetchRequest<Dream>(entityName: "Dream")
        fetch.sortDescriptors = []
        fetch.fetchLimit = 1
        fetch.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Dream.id), id]
        )
        
        do{
            let results = try managedObjectContext.fetch(fetch)
            if results.count == 0{
                return nil
            }
            return results.first
        }catch{
            return nil
        }
    }
}

//MARK: - DELETE SAVE UPDATE

extension Dream{
        
    func setDreamValues(from dreamViewModel : DreamViewModel, context managedObjectContext: NSManagedObjectContext){
        self.id = dreamViewModel.id
        self.title = dreamViewModel.title.isEmpty ? "Title" : dreamViewModel.title
        self.text = dreamViewModel.text
        self.date = dreamViewModel.date
        self.isBookmarked = dreamViewModel.isBookmarked
        self.isLucid = dreamViewModel.isLucid
        self.isNightmare = dreamViewModel.isNightmare
        self.tags = NSOrderedSet(array: dreamViewModel.tags.map({Tag.createTag(from: $0, context: managedObjectContext)}))
    }
    
    @nonobjc class func saveDream(_ dreamViewModel : DreamViewModel, context managedObjectContext: NSManagedObjectContext) throws{
        let dream = Dream(entity: Dream.entity(), insertInto: managedObjectContext)
        dream.setDreamValues(from: dreamViewModel, context: managedObjectContext)
        
        do{
            try dream.validateForInsert()
            managedObjectContext.insert(dream)
            try managedObjectContext.save()
        }catch let error as NSError{
            managedObjectContext.reset()
            throw DreamError.invalidSave(error: error.localizedDescription)
        }
    }
    
    @nonobjc class func updateDream(_ dreamViewModel : DreamViewModel, context managedObjectContext: NSManagedObjectContext) throws{
        guard let dream = Dream.fetchDream(id: dreamViewModel.id, context: managedObjectContext) else{
            throw DreamError.updatingNonExistingDream
        }
        
        dream.setDreamValues(from: dreamViewModel, context: managedObjectContext)
        
        do{
            try dream.validateForUpdate()
            try managedObjectContext.save()
        }catch let error as NSError{
            managedObjectContext.reset()
            throw DreamError.invalidUpdate(error: error.localizedDescription)
        }
    }
    
    @nonobjc class func deleteDream(_ dreamViewModel : DreamViewModel, context managedObjectContext: NSManagedObjectContext) throws{
        guard let dream = fetchDream(id: dreamViewModel.id, context: managedObjectContext)else{
            throw Dream.DreamError.deletingNonExistingDream
        }
        
        do{
            managedObjectContext.delete(dream)
            try managedObjectContext.save()
        }catch let error as NSError{
            managedObjectContext.reset()
            throw DreamError.invalidDelete(error: error.localizedDescription)
        }
    }
    
    enum DreamError : Error {
        case updatingNonExistingDream
        case deletingNonExistingDream
        case invalidUpdate(error : String)
        case invalidSave(error : String)
        case invalidDelete(error : String)
    }
}

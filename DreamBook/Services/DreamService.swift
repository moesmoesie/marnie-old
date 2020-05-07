//
//  DreamService.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import CoreData

public class DreamService{
    private let managedObjectContext : NSManagedObjectContext
    
    init(managedObjectContext : NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
}

extension DreamService{
    func saveDream(dreamViewModel : DreamViewModel) throws {
        let dream = Dream(entity: Dream.entity(), insertInto: self.managedObjectContext)
        dream.id = dreamViewModel.id
        dream.isBookmarked = dreamViewModel.isBookmarked
        dream.date = dreamViewModel.date
        dream.title = dreamViewModel.title
        dream.text = dreamViewModel.text
        
        for tagViewModel in dreamViewModel.tags {
            let tag = Tag(context: self.managedObjectContext)
            tag.text = tagViewModel.text
            dream.addToTags(tag)
        }
        
        do{
            try dream.validateForInsert()
            self.managedObjectContext.insert(dream)
            try self.managedObjectContext.save()
        }catch let error as NSError{
            throw DreamError.invalidSave(error: error.localizedDescription)
        }
    }
    
    func updateDream(dreamViewModel : DreamViewModel) throws {
        guard let dream = getDream(id: dreamViewModel.id)else{
            throw DreamError.updatingNonExistingDream
        }
        let tagService = TagService(managedObjectContext: self.managedObjectContext)
        
        dream.title = dreamViewModel.title
        dream.text = dreamViewModel.text
        dream.isBookmarked = dreamViewModel.isBookmarked
        dream.date = dreamViewModel.date
        dream.tags = []
        for tagViewModel in dreamViewModel.tags {
            let tag = Tag(context: self.managedObjectContext)
            tag.text = tagViewModel.text
            dream.addToTags(tag)
        }
        
        do{
            try dream.validateForUpdate()
            try self.managedObjectContext.save()
            tagService.deleteDreamlessTags()
        }catch let error as NSError{
            throw DreamError.invalidSave(error: error.localizedDescription)
        }
    }
    
    func deleteDream(_ dreamViewModel : DreamViewModel) throws {
        guard let dream = getDream(id: dreamViewModel.id)else{
            throw DreamService.DreamError.deletingNonExistingDream
        }
        
        do{
            self.managedObjectContext.delete(dream)
            try self.managedObjectContext.save()
        }catch let error as NSError{
            throw DreamError.invalidDelete(error: error.localizedDescription)
        }
    }
    
    func getDream(id : UUID) -> Dream?{
        let fetchRequest : NSFetchRequest<Dream> = Dream.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Dream.id), id]
        )
        
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count == 0{
                return nil
            }
            return results.first
        }catch{
            return nil
        }
    }
}

extension DreamService {
    enum DreamError : Error {
        case updatingNonExistingDream
        case deletingNonExistingDream
        case invalidUpdate(error : String)
        case invalidSave(error : String)
        case invalidDelete(error : String)
    }
}

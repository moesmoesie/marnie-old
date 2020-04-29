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
    func saveDream(title:String?, text:String?) throws {
        let dream = Dream(entity: Dream.entity(), insertInto: nil)
        dream.id = UUID()
        if let title = title{
            dream.title = title.isEmpty ? nil : title
        }
        dream.text = text
        
        do{
            try dream.validateForInsert()
            self.managedObjectContext.insert(dream)
            try self.managedObjectContext.save()
        }catch let error as NSError{
            throw DreamError.invalidSave(error: error.localizedDescription)
        }
    }
    
    func updateDream(_ dream : Dream, title:String?, text:String?) throws {
        dream.title = title ?? dream.title
        dream.text = text ?? dream.text
        
        do{
            try self.managedObjectContext.existingObject(with: dream.objectID)
        }catch{
            throw DreamError.updatingNonExistingDream
        }
        
        do{
            try dream.validateForUpdate()
            try self.managedObjectContext.save()
        }catch let error as NSError{
            throw DreamError.invalidSave(error: error.localizedDescription)
        }
    }
    
    func deleteDream(_ dream : Dream) throws {
        do{
            try dream.validateForDelete()
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
        case invalidUpdate(error : String)
        case invalidSave(error : String)
        case invalidDelete(error : String)
    }
}

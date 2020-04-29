//
//  Dream+CoreDataClass.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Dream)
public class Dream: NSManagedObject {
    static func saveDream(moc : NSManagedObjectContext,title:String?, text:String?) throws {
        let dream = Dream(entity: Dream.entity(), insertInto: nil)
        dream.id = UUID()
        if let title = title{
            dream.title = title.isEmpty ? nil : title
        }
        dream.text = text
        
        do{
            try dream.validateForInsert()
            moc.insert(dream)
            try moc.save()
        }catch let error as NSError{
            throw DreamError.invalidSave(error: error.localizedDescription)
        }
    }
    
    func updateDream(moc : NSManagedObjectContext,title:String?, text:String?) throws {
        self.title = title ?? self.title
        self.text = text ?? self.text
        
        do{
            try moc.existingObject(with: self.objectID)
        }catch{
            throw DreamError.updatingNonExistingDream
        }
        
        do{
            try self.validateForUpdate()
            try moc.save()
        }catch let error as NSError{
            throw DreamError.invalidSave(error: error.localizedDescription)
        }
    }
    
    func deleteDream(context : NSManagedObjectContext) throws {
        context.performAndWait {
            context.delete(self)
        }
        
        do{
            try context.save()
        }catch let error as NSError{
            throw DreamError.invalidDelete(error: error.localizedDescription)
        }
    }
    
    
    enum DreamError : Error {
        case updatingNonExistingDream
        case invalidUpdate(error : String)
        case invalidSave(error : String)
        case invalidDelete(error : String)
    }
}

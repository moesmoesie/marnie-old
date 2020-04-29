//
//  CoreDataStack.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    private let modelName : String
    private let inMemory : Bool
    
    init(modelName : String, inMemory : Bool = false) {
        self.modelName = modelName
        self.inMemory = inMemory
    }
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer : NSPersistentContainer = {
       let container = NSPersistentContainer(name: modelName)
        if self.inMemory{
            let storeDescription = NSPersistentStoreDescription()
            storeDescription.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [storeDescription]
        }
        container.loadPersistentStores { (storeDescription, error) in
            print("Error loading store")
        }
        return container
    }()
}

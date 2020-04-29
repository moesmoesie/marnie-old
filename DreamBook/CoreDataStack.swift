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
    public static let modelName = "DreamBook"
    
    public static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        self.storeContainer.viewContext
    }()
    
    lazy var storeContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
        
        container.loadPersistentStores { (storeDescription, error) in
            print("Error loading store")
        }
        return container
    }()
    
    func saveContext () {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)") }
    }
}

class InMemoryCoreDataStack: CoreDataStack {
    override init() {
        super.init()
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
        let storeDescription = NSPersistentStoreDescription()
        
        storeDescription.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { (storeDescription, error) in
            print("Error loading store")
        }
        
        self.storeContainer = container
    }
}

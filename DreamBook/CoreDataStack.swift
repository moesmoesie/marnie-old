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
    
    init(modelName : String) {
        self.modelName = modelName
    }
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer : NSPersistentContainer = {
       let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (storeDescription, error) in
            print("Error loading store")
        }
        return container
    }()
    
}

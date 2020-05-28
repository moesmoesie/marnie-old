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
        loadDreams()
    }
}

//MARK: - READ

extension DreamStore{
    
    func loadDreams(filterViewModels : [FilterViewModel] = []){
        let fetch = Dream.customFetchRequest(filterViewModels: filterViewModels)
        
        do {
            let fetchedDreams =  try managedObjectContext.fetch(fetch)
            self.dreams = fetchedDreams.map({DreamViewModel(dream: $0)})
        }  catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func asyncLoadDreams(filterViewModels : [FilterViewModel] = [] ,onComplete: @escaping () -> ()){
        let fetch = Dream.customFetchRequest(filterViewModels: filterViewModels)
        let asyncFetch = NSAsynchronousFetchRequest<Dream>(fetchRequest: fetch) { (results : NSAsynchronousFetchResult) in
            guard let fetchedDreams = results.finalResult else{
                return
            }
            
            self.dreams = fetchedDreams.map({DreamViewModel(dream: $0)})
            onComplete()
        }
        
        do {
            try managedObjectContext.execute(asyncFetch)
        }  catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}


//MARK: - CREATE UPDATE
extension DreamStore{
    func saveDream(_ dreamViewModel : DreamViewModel) throws {
        let dream = Dream.getDream(from: dreamViewModel, context: self.managedObjectContext)
        do{
            try dream.validateForInsert()
            self.managedObjectContext.insert(dream)
            try self.managedObjectContext.save()
        }catch let error as NSError{
            self.managedObjectContext.reset()
            throw DreamError.invalidSave(error: error.localizedDescription)
        }
    }
}

//MARK: - ERRORS
extension DreamStore{
    enum DreamError : Error {
        case updatingNonExistingDream
        case deletingNonExistingDream
        case invalidUpdate(error : String)
        case invalidSave(error : String)
        case invalidDelete(error : String)
    }
}

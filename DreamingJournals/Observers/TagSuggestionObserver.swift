//
//  TagSuggestionObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 07/06/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//
import SwiftUI
import CoreData

class TagSuggestionObserver : ObservableObject{
    @Published var suggestionTags : [TagViewModel] = []
    let context =  (UIApplication.shared.delegate as! AppDelegate).coreDataStack.managedObjectContext
    
    init() {
        suggestionTags = getUniqueTags(text: "")
    }
    
    func getUniqueTags(text : String) -> [TagViewModel]{
        let fetch : NSFetchRequest<NSDictionary> = Tag.uniqueTagTextFetch()
        fetch.fetchLimit = 50

        if !text.isEmpty{
            let predicate = NSPredicate(format: "text contains %@", text)
            fetch.predicate = predicate
        }

        do {
            let fetchedTags = try self.context.fetch(fetch)
            return fetchedTags.map({TagViewModel(text: $0["text"] as! String)})
        } catch {
            print("Error")
            return []
        }
    }
}

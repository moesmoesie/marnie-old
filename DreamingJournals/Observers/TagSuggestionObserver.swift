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
    @Published var textSuggestionTags : [TagViewModel] = []

    let context =  (UIApplication.shared.delegate as! AppDelegate).coreDataStack.managedObjectContext
    
    init() {
        suggestionTags = getUniqueTags(text: "")
    }
    
    func updateTagSuggestions(text : String){
        let setences = text.components(separatedBy: CharacterSet(charactersIn: "!.?"))
        var tags : [TagViewModel] = []
        for sentence in setences.suffix(3){
            for word in sentence.split(separator: " "){
                let tag = TagViewModel(text: word.capitalized)
                if !tags.contains(tag) && tag.text.count > 3 {
                    tags.append(tag)
                }
            }
        }
    
        tags.sort { (tag, tag2) -> Bool in
            tag.text.count > tag2.text.count
        }
        
        self.textSuggestionTags = tags
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

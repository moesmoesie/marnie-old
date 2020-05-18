//
//  SuggestionTagsObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 18/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import Combine
import NaturalLanguage
private var cancellableSet: Set<AnyCancellable> = []

class SuggestionTagsObserver : ObservableObject{
    @Published var text : String = ""
    @Published var tags : [TagViewModel] = []
    
    init() {
        self.$text.debounce(for: 0.4, scheduler: RunLoop.main)
            .sink { (text) in
            let tagger = NLTagger(tagSchemes: [.nameType])
            tagger.string = text
            let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace ,.joinNames]
            let goodTags: [NLTag] = [.personalName, .placeName, .organizationName]

            var tempTags : [TagViewModel] = []
            tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
                if let tag = tag, goodTags.contains(tag) {
                    let tagText = String(text[tokenRange]).capitalized
                    let newTag = TagViewModel(text: tagText)
                    tempTags.append(newTag)
                }
                return true
            }
                                
            for tag in tempTags{
                if !self.tags.contains(tag){
                    self.tags.append(tag)
                }
            }
                
            for tag in self.tags{
                if !tempTags.contains(tag){
                    if let index = self.tags.firstIndex(of: tag){
                        self.tags.remove(at: index)
                    }
                }
            }
 
        }.store(in: &cancellableSet)
    }
}

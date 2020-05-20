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
    let tagger = NLTagger(tagSchemes: [.nameType])
    let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace ,.joinNames]
    let goodTags: [NLTag] = [.personalName, .placeName, .organizationName]
    let allTags : [TagViewModel]
    init(allTags : [TagViewModel]) {
        self.allTags = allTags
        self.$text.debounce(for: 0.2, scheduler: RunLoop.main)
            .sink { (text) in
                
                var tempTags : [TagViewModel] = self.nlpTagCheck(text: text)
                tempTags.append(contentsOf: self.manualTagCheck(text: String(text.suffix(20))))
                
                
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
    
    func nlpTagCheck(text: String) -> [TagViewModel]{
        tagger.string = text
        var tempTags : [TagViewModel] = []
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .nameType, options: options) { tag, tokenRange in
            if let tag = tag, goodTags.contains(tag) {
                let tagText = String(text[tokenRange]).capitalized
                let newTag = TagViewModel(text: tagText)
                tempTags.append(newTag)
            }
            return true
        }
        return tempTags
    }
    
    func manualTagCheck(text: String) -> [TagViewModel]{
        let words = text.split(separator: " ")
        var tempTags : [TagViewModel] = []
        for word in words{
            for tag in allTags{
                if self.levDis(String(word.lowercased()), tag.text.lowercased()) < 2{
                    tempTags.append(tag)
                }
            }
        }
        return tempTags
    }
    
    func levDis(_ w1: String, _ w2: String) -> Int {
        let empty = [Int](repeating:0, count: w2.count)
        var last = [Int](0...w2.count)
        
        for (i, char1) in w1.enumerated() {
            var cur = [i + 1] + empty
            for (j, char2) in w2.enumerated() {
                cur[j + 1] = char1 == char2 ? last[j] : min(last[j], last[j + 1], cur[j]) + 1
            }
            last = cur
        }
        return last.last!
    }
}

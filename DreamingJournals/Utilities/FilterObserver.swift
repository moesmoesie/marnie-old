//
//  FilterObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation

class FilterObserver : ObservableObject{
    @Published var tagFilters : [TagViewModel] = []
    @Published var showOnlyFave = false
    
    
    func filteredDreams(dreams : [DreamViewModel]) -> [DreamViewModel]{
        return dreams.filter { (dream) -> Bool in
            tagFilter(dream) && bookmarkFilter(dream)
        }
    }
    
    private func tagFilter(_ dream : DreamViewModel) -> Bool{
        for filter in self.tagFilters{
            if !dream.tags.contains(where: {$0.text == filter.text}){
                return false
            }
        }
        return true
    }
    
    private func bookmarkFilter(_ dream : DreamViewModel) -> Bool{
        if !self.showOnlyFave{
            return true
        }
        return dream.isBookmarked
    }
}

//
//  FilterViewModel.swift
//  DreamingJournals
//
//  Created by moesmoesie on 15/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation

struct FilterViewModel : Identifiable{
    let id = UUID()
    var filter : Filter
}

enum Filter{
    case tag(TagViewModel)
    case bookmarked(Bool)
    
    static func dreams(_ allDreams : [DreamViewModel],filters: [Self]) -> [DreamViewModel]{
        allDreams.filter({ dream in
            for filter in filters{
                if !Self.filterDream(dream,filter){
                    return false
                }
            }
            return true
        })
    }
    
    static private func filterDream(_ dream : DreamViewModel, _ filter : Filter) -> Bool{
        switch filter {
        case .bookmarked(let isBookmarked):
            return bookmarkFilter(dream, isBookmarked)
        case .tag(let tag):
            return tagFilter(dream, tag)
        }
    }
    
    static private func tagFilter(_ dream : DreamViewModel, _ tag : TagViewModel) -> Bool{
          return dream.tags.contains(where: {$0.text == tag.text})
    }
    
    static private func bookmarkFilter(_ dream : DreamViewModel, _ isBookmarked: Bool) -> Bool{
        if !isBookmarked{
            return true
        }
        return dream.isBookmarked
    }
}

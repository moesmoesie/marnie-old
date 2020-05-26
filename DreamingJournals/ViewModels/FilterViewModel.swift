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
    case lucid(Bool)
    case nightmare(Bool)
    
    public func areEqual(filter : Self) -> Bool{
        switch (self,filter) {
        case let (.tag(a), .tag(b)):
            return a.text == b.text
        case let (.bookmarked(a), .bookmarked(b)):
            return a == b
        case let (.lucid(a), .lucid(b)):
            return a == b
        case let (.nightmare(a), .nightmare(b)):
            return a == b
        default:
            return false
        }
    }
    
    public func areEqualType(filter : Self) -> Bool{
        switch (self,filter) {
        case (.tag(_), .tag(_)):
            return true
        case (.bookmarked(_), .bookmarked(_)):
            return true
        case (.lucid(_), .lucid(_)):
            return true
        case (.nightmare(_), .nightmare(_)):
            return true
        default:
            return false
        }
    }
    
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
            case .lucid(let isLucid):
                return lucidFilter(dream, isLucid)
            case .nightmare(let isNightmare):
                return nightmareFilter(dream, isNightmare)
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
    
    static private func lucidFilter(_ dream : DreamViewModel, _ isLucid: Bool) -> Bool{
        if !isLucid{
            return true
        }
        return dream.isLucid
    }
    
    static private func nightmareFilter(_ dream : DreamViewModel, _ isNightmare: Bool) -> Bool{
        if !isNightmare{
            return true
        }
        return dream.isNightmare
    }
}

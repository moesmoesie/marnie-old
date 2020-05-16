//
//  FilterObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation

class FilterObserver : ObservableObject{
    @Published var filters : [FilterViewModel] = []
    
    var tagFilters : [TagViewModel]{
        var temp : [TagViewModel] = []
        for filter in filters{
            switch filter.filter {
            case .tag(let tag):
                temp.append(tag)
            default: break
            }
        }
        return temp
    }
    
    var bookmarkedFilters : [Bool]{
        var temp : [Bool] = []
        for filter in filters{
            switch filter.filter {
            case .bookmarked(let isBookmarked):
                temp.append(isBookmarked)
            default: break
            }
        }
        return temp
    }
}

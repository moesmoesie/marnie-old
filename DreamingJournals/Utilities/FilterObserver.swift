//
//  FilterObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import CoreData
import Combine

class FilterObserver : ObservableObject{
    @Published var filters : [FilterViewModel] = []
    @Published var availableFilters : [FilterViewModel] = []
    private var allFilters : [FilterViewModel] = []
    
    var containsTagFilter : Bool{
        filters.contains(where: {$0.filter.areEqualType(filter: .tag(TagViewModel(text: "")))})
    }
    
    var containsBookmarkFilter : Bool{
        filters.contains(where: {$0.filter.areEqualType(filter: .bookmarked(false))})
    }
    
    var containsNightmareFilter : Bool{
        filters.contains(where: {$0.filter.areEqualType(filter: .nightmare(false))})
    }
    
    var containsLucidFilter : Bool{
        filters.contains(where: {$0.filter.areEqualType(filter: .lucid(false))})
    }
    
    
    func isFilterTypeActive(filter : FilterViewModel) -> Bool{
        switch filter.filter {
        case .bookmarked(_):
            return containsBookmarkFilter
        case .lucid(_):
            return containsLucidFilter
        case .nightmare(_):
            return containsNightmareFilter
        case .tag(_):
            return containsTagFilter
        }
    }
    
    func onTagsUpdate(tags : [TagViewModel]){
        var uniqueTags : [TagViewModel] = []
        for tag in tags{
            if !uniqueTags.contains(tag){
                uniqueTags.append(tag)
            }
        }
        let filterTags = uniqueTags.map({self.getTagFilter(tagViewModel: $0)})
        self.allFilters = []
        self.allFilters.append(contentsOf: filterTags)
        self.availableFilters = allFilters
        for (filter) in self.filters{
            if !self.allFilters.contains(where: {filter.filter.areEqual(filter: $0.filter)}){
                if let index = self.filters.firstIndex(where: {filter.filter.areEqual(filter: $0.filter)}){
                    self.filters.remove(at: index)
                }
            }
        }
    }
    
    func onFilteredTagsUpdate(filters : [FilterViewModel]){
        for filter in allFilters{
            if !self.availableFilters.contains(where: {filter.filter.areEqual(filter: $0.filter)}){
                self.availableFilters.append(filter)
            }
        }
        
        for filter in filters{
            if let index = self.availableFilters.firstIndex(where: {filter.filter.areEqual(filter: $0.filter)}){
                self.availableFilters.remove(at: index)
            }
        }
    }
    
    private func getTagFilter(tagViewModel : TagViewModel) -> FilterViewModel{
        FilterViewModel(filter: .tag(tagViewModel))
    }
    
    private func getBookmarkedFilter(isBookmarked : Bool) -> FilterViewModel{
        FilterViewModel(filter: .bookmarked(isBookmarked))
    }
}

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
    private let managedObjectContext : NSManagedObjectContext
    private var cancellableSet: Set<AnyCancellable> = []

    private var allFilters : [FilterViewModel] = []
    
    init(managedObjectContext : NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.onTagsUpdate()
        NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave, object: self.managedObjectContext)
            .sink(receiveValue: { _ in
                self.onTagsUpdate()
            }).store(in: &cancellableSet)
        
        self.$filters.sink(receiveValue: onFilteredTagsUpdate)
            .store(in: &cancellableSet)
    }
    
    private func onTagsUpdate(){
        let tagService = TagService(managedObjectContext: managedObjectContext)
        tagService.deleteDreamlessTags()
        self.allFilters = []
        let tags = tagService.getUniqueTags()
        let filterTags = tags.map({self.getTagFilter(tagViewModel: $0)})
        let bookmarkFilter = FilterViewModel(filter : .bookmarked(true))
        self.allFilters.append(contentsOf: filterTags)
        self.availableFilters = allFilters
        for (index,filter) in self.filters.enumerated(){
            if !self.allFilters.contains(where: {filter.filter.areEqual(filter: $0.filter)}){
                self.filters.remove(at: index)
            }
        }
        
        self.allFilters.append(bookmarkFilter)
    }
    
    private func onFilteredTagsUpdate(filters : [FilterViewModel]){
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

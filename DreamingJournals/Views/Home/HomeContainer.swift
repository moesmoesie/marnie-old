//
//  HomeView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct HomeContainer: View {
    @EnvironmentObject var filterObserver : FilterObserver
    @FetchRequest(entity: Dream.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \Dream.date, ascending: false)])var fetchedDreams: FetchedResults<Dream>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var filteredDreams : [DreamViewModel]{
        let dreams = fetchedDreams.map({DreamViewModel(dream: $0)})
        return Filter.dreams(dreams, filters: filterObserver.filters.map{$0.filter})
    }
    
    var body: some View {
        let tagUpdatePublisher = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextDidSave, object: self.managedObjectContext)
        
        
        return NavigationView{
            HomeView(dreams: filteredDreams)
                .onReceive(tagUpdatePublisher){ _ in
                    self.updateTags()
            }
        }.onAppear(perform: onAppear)
        .onReceive(filterObserver.$filters, perform: filterObserver.onFilteredTagsUpdate)
    }
    
    func updateTags(){
        let tagService = TagService(managedObjectContext: self.managedObjectContext)
        self.filterObserver.onTagsUpdate(tags: tagService.getUniqueTags())
    }
    
    func onAppear(){
        removeTableViewBackground()
        updateTags()
    }
}

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
    
    var filteredDreams : [DreamViewModel]{
        let dreams = fetchedDreams.map({DreamViewModel(dream: $0)})
        return Filter.dreams(dreams, filters: filterObserver.filters.map{$0.filter})
    }
    
    var body: some View {
        NavigationView{
            HomeView(dreams: filteredDreams)
        }.onAppear(perform: removeTableViewBackground)
    }
}

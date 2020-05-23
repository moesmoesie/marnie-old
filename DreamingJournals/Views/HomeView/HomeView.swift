//
//  HomeView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var navigationObserver : NavigationObserver
    @EnvironmentObject var filterObserver : FilterObserver
    @FetchRequest(entity: Dream.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \Dream.date, ascending: false)])var fetchedDreams: FetchedResults<Dream>
    
    var filteredDreams : [DreamViewModel]{
        let dreams = fetchedDreams.map({DreamViewModel(dream: $0)})
        return Filter.dreams(dreams, filters: filterObserver.filters.map{$0.filter})
    }
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .topLeading){
                Color.background1.edgesIgnoringSafeArea(.all)
                DreamList(dreams: filteredDreams)
            }
            .onAppear(perform: viewSetup)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
    
    private func viewSetup(){
        if !self.navigationObserver.showBottomBar{
            self.navigationObserver.showBottomBar = true
        }
        styleUITableView()
    }
    
    private func styleUITableView(){
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = .clear
        UITableViewCell.appearance().selectionStyle = .none
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

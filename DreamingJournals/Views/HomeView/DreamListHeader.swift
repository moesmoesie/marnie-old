//
//  DreamListHeader.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct ListHeader : View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var navigationObserver : NavigationObserver
    @EnvironmentObject var filterObserver : FilterObserver
    @Environment(\.managedObjectContext) var moc
    
    @State var showNewDream : Bool = false
    @State var showFilterSheet : Bool = false
    
    var body: some View{
        return ZStack{
            NavigationLink(destination: DreamDetailView(dream: DreamViewModel()), isActive: self.$showNewDream){EmptyView()}.disabled(true).hidden()
            HStack(alignment:.firstTextBaseline, spacing: theme.mediumPadding){
                title
                Spacer()
                addDreamButton
                filterButton
            }
        }
    }
    
    
    //MARK: - HELPER VIEWS
    
    private var title : some View{
        Text("Dreams")
            .font(theme.secundaryLargeFont)
            .foregroundColor(theme.textColor)
    }
    
     private var addDreamButton : some View{
        Image(systemName: "plus.circle.fill")
            .resizable()
            .foregroundColor(theme.secondaryColor)
            .frame(width : theme.largePadding, height: theme.largePadding)
            .padding(.bottom, -2)
            .onTapGesture {
                self.showNewDream = true
                self.navigationObserver.showBottomBar = false
        }
    }
    
    private var filterButton : some View{
        Button(action:{
            self.showFilterSheet = true
        }){
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .foregroundColor(filterObserver.filters.isEmpty ? theme.secondaryColor : theme.primaryColor)
                .frame(width : theme.largePadding, height: theme.largePadding)
                .padding(.bottom, -2)
        }.sheet(isPresented: $showFilterSheet) {
            DreamFilterSheetView()
                .environmentObject(self.theme)
                .environmentObject(self.filterObserver)
                .environment(\.managedObjectContext, self.moc)
        }
    }
}

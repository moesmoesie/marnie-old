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
    
    var body: some View{
        return
            HStack(spacing: 0){
                title.padding(.leading, theme.extraSmallPadding)
                Spacer()
                FilterButtonView()
                AddDreamButtonView()
        }
    }
    
    
    //MARK: - HELPER VIEWS
    
    private var title : some View{
        Text("Dreams")
            .font(theme.secundaryLargeFont)
            .foregroundColor(theme.primaryTextColor)
    }
}


struct FilterButtonView : View {
    @State var showSheet = false
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var filterObserver : FilterObserver
    @Environment(\.managedObjectContext) var moc
    
    var body : some View{
        Button(action: {
            self.showSheet = true
        }){
            Image(systemName: "magnifyingglass.circle.fill")
                .foregroundColor(filterObserver.filters.isEmpty ? theme.unSelectedAccentColor : theme.selectedAccentColor)
                .font(.largeTitle)
                .background(self.theme.primaryBackgroundColor)
        }.sheet(isPresented: $showSheet){
                DreamFilterSheetView()
                     .environmentObject(self.theme)
                     .environmentObject(self.filterObserver)
                     .environment(\.managedObjectContext, self.moc)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct AddDreamButtonView : View {
    @State var showNewDream = false
    @EnvironmentObject var theme : Theme
    var body : some View{
        ZStack{
            NavigationLink(destination: DreamDetailView(dream: DreamViewModel()), isActive: self.$showNewDream){
                EmptyView()
            }.hidden().disabled(true).frame(width:.zero, height: .zero)
            Button(action: {
                self.showNewDream = true
            }){
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(self.theme.secondaryAccentColor)
                    .font(.largeTitle)
                    .background(self.theme.primaryBackgroundColor)
                    .padding(self.theme.mediumPadding)
            }.buttonStyle(PlainButtonStyle())
        }
    }
}




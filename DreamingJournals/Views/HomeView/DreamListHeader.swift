//
//  DreamListHeader.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct ListHeader : View {
    
    
    @EnvironmentObject var filterObserver : FilterObserver
    @Environment(\.managedObjectContext) var moc
    
    var body: some View{
        return
            HStack(spacing: 0){
                title.padding(.leading, .extraSmall)
                Spacer()
                FilterButtonView()
                AddDreamButtonView()
        }
    }
    
    
    //MARK: - HELPER VIEWS
    
    private var title : some View{
        Text("Dreams")
            .font(Font.secondaryLarge)
            .foregroundColor(.primary)
    }
}


struct FilterButtonView : View {
    @State var showSheet = false
    
    @EnvironmentObject var filterObserver : FilterObserver
    @Environment(\.managedObjectContext) var moc
    
    var body : some View{
        Button(action: {
            mediumFeedback()
            self.showSheet = true
        }){
            Image(systemName: "magnifyingglass.circle.fill")
                .foregroundColor(filterObserver.filters.isEmpty ? Color.secondary : Color.accent1)
                .font(.largeTitle)
                .background(Color.background1)
        }.sheet(isPresented: $showSheet){
                DreamFilterSheetView()
                     .environmentObject(self.filterObserver)
                     .environment(\.managedObjectContext, self.moc)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct AddDreamButtonView : View {
    @State var showNewDream = false
    
    var body : some View{
        ZStack{
            NavigationLink(destination: DreamDetailView(dream: DreamViewModel()), isActive: self.$showNewDream){
                EmptyView()
            }.hidden().disabled(true).frame(width:.zero, height: .zero)
            Button(action: {
                mediumFeedback()
                self.showNewDream = true
            }){
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.accent2)
                    .font(.largeTitle)
                    .background(Color.background2)
                    .padding(.medium)
            }.buttonStyle(PlainButtonStyle())
        }
    }
}




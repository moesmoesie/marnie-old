//
//  DreamListView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamListView: View {
    @FetchRequest(entity: Dream.entity(), sortDescriptors: [
        NSSortDescriptor(key: "date", ascending: false)
    ]) var dreams : FetchedResults<Dream>
    @EnvironmentObject var theme : Theme
    @State var showDream = false
    var body: some View {
        List{
            ListHeader()
            ForEach(dreams.map({DreamViewModel(dream: $0)})){ (dream : DreamViewModel) in
                ListItem(dream: dream)
                    .listRowInsets(EdgeInsets())
                    .padding(self.theme.mediumPadding)
                    .background(self.theme.secundaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: self.theme.mediumPadding))
                    .padding(.horizontal, self.theme.mediumPadding)
                    .padding(.bottom, self.theme.mediumPadding)
            }
            Spacer().frame(height : theme.smallPadding * 3)
        }
        .onAppear{
            UITableView.appearance().backgroundColor = .clear
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = .clear
            UITableViewCell.appearance().selectionStyle = .none
        }
    }
}

struct DreamListView_Previews: PreviewProvider {
    static var previews: some View {
        DreamListView()
    }
}

private struct ListItem : View {
    @EnvironmentObject var theme : Theme
    let dream : DreamViewModel
    @State var showDream : Bool = false
    @EnvironmentObject var navigationObserver : NavigationObserver
    
    var body: some View{
        ZStack{
            NavigationLink(destination: DreamDetailView(dream: dream), isActive: self.$showDream){EmptyView()}.disabled(true).hidden()
            VStack(alignment: .leading, spacing: theme.smallPadding * 0.6){
                HStack{
                    Text(dream.wrapperDateString).font(theme.primarySmallFont).foregroundColor(theme.primaryColor)
                    Spacer()
                    if dream.isBookmarked{
                        Image(systemName: "heart.fill").foregroundColor(self.theme.primaryColor)                        }
                }
                Text(dream.title).font(theme.primaryLargeFont).foregroundColor(self.theme.textTitleColor)
                
                if !dream.tags.isEmpty{
                    TagCollectionView(dream, maxRows: 1)
                }
                
                Text(dream.text.replacingOccurrences(of: "\n", with: "")).lineLimit(6).foregroundColor(self.theme.textBodyColor)
            }
        }.overlay(theme.primaryBackgroundColor.opacity(0.0000001)) //getto fix
            .onTapGesture {
                self.navigationObserver.showBottomBar = false
                self.showDream = true
        }
    }
}


private struct ListHeader : View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var navigationObserver : NavigationObserver
    
    @State var showNewDream : Bool = false
    var body: some View{
        VStack(alignment : .center, spacing: 0){
            NavigationLink(destination: DreamDetailView(dream: DreamViewModel()), isActive: self.$showNewDream){EmptyView()}.disabled(true)
            Image(systemName: "moon.fill")
                .resizable()
                .foregroundColor(theme.secundaryColor)
                .frame(width : theme.largePadding * 2, height: theme.largePadding * 2)
                .padding(.bottom, theme.mediumPadding)
            
            HStack(alignment:.firstTextBaseline, spacing: theme.mediumPadding){
                Text("Dreams").font(theme.secundaryLargeFont).foregroundColor(theme.textTitleColor)
                Spacer()
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable()
                    .foregroundColor(theme.secundaryColor)
                    .frame(width : theme.largePadding, height: theme.largePadding)
                    .padding(.bottom, -2)
                    
                    .onTapGesture {
                        print("Show Filter Sheet")
                }
                
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundColor(theme.secundaryColor)
                    .frame(width : theme.largePadding, height: theme.largePadding)
                    .padding(.bottom, -2)
                    .onTapGesture {
                        self.showNewDream = true
                        self.navigationObserver.showBottomBar = false
                }
            }
        }
    }
}

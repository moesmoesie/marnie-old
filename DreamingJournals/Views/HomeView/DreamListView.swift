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
    @EnvironmentObject var filterObserver : FilterObserver
    var body: some View {
        List{
            ListHeader()
                .listRowInsets(EdgeInsets())
                .padding(.horizontal, self.theme.mediumPadding)
                .padding(.bottom, self.theme.smallPadding)
            
            ForEach(dreams.map({DreamViewModel(dream: $0)}).filter({ dream in
                if filterObserver.tagFilters.isEmpty{
                    return true
                }
                
                for tag in filterObserver.tagFilters{
                    if !dream.tags.contains(where: {tag.text == $0.text}){
                        return false
                    }
                }
                return true
            })){ (dream : DreamViewModel) in
                ListItem(dream: dream)
                    .listRowInsets(EdgeInsets())
                    .padding(self.theme.mediumPadding)
                    .background(self.theme.secundaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: self.theme.mediumPadding))
                    .padding(.horizontal, self.theme.mediumPadding)
                    .padding(.bottom, self.theme.mediumPadding)
            }
            Spacer().frame(height : theme.largePadding + getBottomSaveArea())
        }
        .onAppear{
            UITableView.appearance().backgroundColor = .clear
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = .clear
            UITableViewCell.appearance().selectionStyle = .none
            UITableView.appearance().showsVerticalScrollIndicator = false
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
    @EnvironmentObject var filterObserver : FilterObserver
    @Environment(\.managedObjectContext) var moc
    
    @State var showNewDream : Bool = false
    @State var showFilterSheet : Bool = false
    var body: some View{
        return ZStack{
            NavigationLink(destination: DreamDetailView(dream: DreamViewModel()), isActive: self.$showNewDream){EmptyView()}.disabled(true).hidden()
            
            HStack(alignment:.firstTextBaseline, spacing: theme.mediumPadding){
                Text("Dreams").font(theme.secundaryLargeFont).foregroundColor(theme.textTitleColor)
                Spacer()
                Button(action:{
                    self.showFilterSheet = true
                }){
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .foregroundColor(filterObserver.tagFilters.isEmpty ? theme.secundaryColor : theme.primaryColor)
                        .frame(width : theme.largePadding, height: theme.largePadding)
                        .padding(.bottom, -2)
                }.sheet(isPresented: $showFilterSheet) {
                    DreamFilterSheetView()
                        .environmentObject(self.theme)
                        .environmentObject(self.filterObserver)
                        .environment(\.managedObjectContext, self.moc)
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

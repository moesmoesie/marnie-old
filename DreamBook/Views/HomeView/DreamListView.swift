//
//  DreamListView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamListView: View {
    @FetchRequest(entity: Dream.entity(), sortDescriptors: []) var dreams : FetchedResults<Dream>
    @EnvironmentObject var theme : Theme
    @State var showNewDream = false
    var body: some View {
        List{
            VStack(alignment : .center, spacing: 0){
                NavigationLink(destination: DreamDetailView(), isActive: self.$showNewDream){EmptyView()}
                Image(systemName: "moon.fill")
                    .resizable()
                    .foregroundColor(theme.secundaryColor)
                    .frame(width : theme.largePadding * 2, height: theme.largePadding * 2)
                    .padding(.bottom, theme.mediumPadding)
                
                HStack(alignment:.firstTextBaseline, spacing: theme.mediumPadding){
                    Text("Dreams").font(.largeTitle).bold().foregroundColor(theme.textTitleColor)
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
                    }
                    
                }
            }.padding(.horizontal,self.theme.mediumPadding)
            ForEach(dreams, id: \.self){ (dream: Dream) in
                VStack(alignment: .leading, spacing: 0){
                    NavigationLink(destination: DreamDetailView(dream: dream)){EmptyView()}.hidden()
                    HStack{
                        Text(dream.wrapperDateString).font(.caption).foregroundColor(self.theme.primaryColor).bold()
                        Spacer()
                        if dream.isBookmarked{
                            Image(systemName: "heart.fill").foregroundColor(self.theme.primaryColor)                        }
                    }
                    .padding(.bottom,3)
                    Text(dream.wrappedTitle).bold().font(.headline).foregroundColor(self.theme.textTitleColor)
                        .padding(.bottom,3)
                    
                    if !dream.wrappedTags.isEmpty{
                        TagCollectionView(tags: .constant(dream.wrappedTags)).padding(.vertical,3)
                    }
                    
                    Text(dream.wrappedText.replacingOccurrences(of: "\n", with: "")).lineLimit(6).foregroundColor(self.theme.textBodyColor)
                }.listRowInsets(EdgeInsets())
                    .padding(self.theme.mediumPadding)
                    .background(self.theme.secundaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: self.theme.mediumPadding))
                    .padding(.horizontal, self.theme.largePadding)
                    .padding(.bottom, self.theme.largePadding)
            }
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

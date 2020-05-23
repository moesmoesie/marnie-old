//
//  DreamListItem.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamListItem : View {
    
    let dream : DreamViewModel
    @State var showDream : Bool = false
    
    
    var body: some View{
        ZStack{
            NavigationLink(destination: DreamDetailView(dream: dream), isActive: self.$showDream){EmptyView()}.disabled(true).hidden()
            VStack(alignment: .leading, spacing: 0){
                topBarView
                    .padding(.bottom, .extraSmall * 0.8)
                titleView
                    .padding(.bottom, .extraSmall)
                if !dream.tags.isEmpty{
                    CollectionView(data: dream.tags, maxRows: 1){ (tag : TagViewModel) in
                        TagView(tag: tag)
                    }.padding(.bottom, .extraSmall)
                }
                textView
            }
        }.overlay(Color.background1.opacity(0.001)) //getto fix
            .onTapGesture(perform: onItemTap)
    }
    
    // MARK: - LOGIC FUNCTIONS
    
    private func onItemTap(){
        self.showDream = true
    }
    
    // MARK: - HELPER VIEWS
    
    private var titleView: some View{
        Text(dream.title)
            .font(Font.primaryLarge)
            .foregroundColor(.primary)
    }
    
    private var textView : some View {
        let textToShow = dream.text.replacingOccurrences(of: "\n", with: "")
        return Text(textToShow)
            .lineLimit(6)
            .foregroundColor(.primary)
    }
    
    private var topBarView : some View{
        HStack{
            dateView
            Spacer()
            if dream.isBookmarked{
                isBookmarkedView
            }
        }
    }
    
    private var dateView : some View{
        Text(dream.wrapperDateString)
            .font(.primarySmall)
            .foregroundColor(.accent1)
    }
    
    private var isBookmarkedView : some View{
        Image(systemName: "heart.fill").foregroundColor(.accent1)
    }
}

//
//  DreamListItem.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamListItem : View {
    @EnvironmentObject var theme : Theme
    let dream : DreamViewModel
    @State var showDream : Bool = false
    @EnvironmentObject var navigationObserver : NavigationObserver
    
    var body: some View{
        ZStack{
            NavigationLink(destination: DreamDetailView(dream: dream), isActive: self.$showDream){EmptyView()}.disabled(true).hidden()
            VStack(alignment: .leading, spacing: 0){
                topBarView
                    .padding(.bottom, theme.extraSmallPadding * 0.8)
                titleView
                    .padding(.bottom, theme.extraSmallPadding)
                if !dream.tags.isEmpty{
                    CollectionView(data: dream.tags, maxRows: 1){ (tag : TagViewModel) in
                        TagView(tag: tag)
                    }.padding(.bottom, theme.extraSmallPadding)
                }
                textView
            }
        }.overlay(theme.backgroundColor.opacity(0.0000001)) //getto fix
            .onTapGesture(perform: onItemTap)
    }
    
    // MARK: - LOGIC FUNCTIONS
    
    private func onItemTap(){
        self.navigationObserver.showBottomBar = false
        self.showDream = true
    }
    
    // MARK: - HELPER VIEWS
    
    private var titleView: some View{
        Text(dream.title)
            .font(theme.primaryLargeFont)
            .foregroundColor(theme.textColor)
    }
    
    private var textView : some View {
        let textToShow = dream.text.replacingOccurrences(of: "\n", with: "")
        return Text(textToShow)
            .lineLimit(6)
            .foregroundColor(self.theme.textColor)
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
            .font(theme.primarySmallFont)
            .foregroundColor(theme.primaryColor)
    }
    
    private var isBookmarkedView : some View{
        Image(systemName: "heart.fill").foregroundColor(self.theme.primaryColor)
    }
}

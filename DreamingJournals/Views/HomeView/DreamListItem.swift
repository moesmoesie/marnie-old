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
            VStack(alignment: .leading, spacing: theme.smallPadding * 0.6){
                topBarView
                titleView
                if !dream.tags.isEmpty{
                    TagCollectionView(dream, maxRows: 1)
                }
                textView
            }
        }.overlay(theme.primaryBackgroundColor.opacity(0.0000001)) //getto fix
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
            .foregroundColor(self.theme.textTitleColor)
    }
    
    private var textView : some View {
        let textToShow = dream.text.replacingOccurrences(of: "\n", with: "")
        return Text(textToShow)
            .lineLimit(6)
            .foregroundColor(self.theme.textBodyColor)
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

//
//  DreamListItem.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct HomeDreamListItemView : View {
    @State var showDetail = false
    let dream : DreamViewModel
    @EnvironmentObject var filterObserver : FilterObserver
    
    init(dream : Dream) {
        self.dream = DreamViewModel(dream: dream)
    }
    
    var body: some View{
        VStack(alignment : .leading, spacing: 0){
            naviagationLink
            ListItemDate(text: dream.wrapperDateString)
            

            ListItemTitle(text: dream.title)
            
            
            if !dream.tags.isEmpty{
                ListItemsTags(tags: dream.tags, filters: filterObserver.filters)
                    .padding(.top, .extraSmall)
            }

            ListItemText(text: dream.text)
                .padding(.vertical, .extraSmall)
            
            ListItemsDetails(dream: dream)
        }
        .padding(.horizontal,.medium)
        .padding(.top, .small)
        .padding(.bottom,.medium)
        .frame(maxWidth : .infinity)
        .background(Color.background1)
        .cornerRadius(30)
        .primaryShadow()
    }
    
    // MARK: - HELPER VIEWS
    
    private var naviagationLink : some View{
        NavigationLink(destination: LazyView(DreamDetailView(dream: self.dream)), isActive: $showDetail){
            EmptyView()
        }.hidden()
    }
}

private struct ListItemsTags : View{
    let tagsToShow : [TagViewModel]
    let filters : [FilterViewModel]
    
    init(tags : [TagViewModel], filters : [FilterViewModel]) {
        self.filters = filters
        self.tagsToShow = tags.sorted { (tag1, tag2) -> Bool in
            let isFilter1 = filters.contains(FilterViewModel(filter: .tag(tag1)))
            let isFilter2 = filters.contains(FilterViewModel(filter: .tag(tag2)))
            
            if isFilter1 && !isFilter2{
                return true
            }
            return false
        }
    }
    
    var body: some View{
        HStack{
            ForEach(tagsToShow.prefix(3)){ tag in
                TagView(
                    tag: tag,
                    isActive: self.filters.contains(FilterViewModel(filter: .tag(tag)))
                )
            }
        }
    }
}


private struct ListItemsDetails : View{
    @EnvironmentObject var filterObserver : FilterObserver
    let dream : DreamViewModel
    
    var body: some View{
        HStack(spacing: .medium){
            if dream.isBookmarked{
                CustomIconButton(
                    icon: Image.bookmarkIcon,
                    iconSize: .medium,
                    isActive: filterObserver.filters.contains(FilterViewModel(filter: .isBookmarked(true)))
                )
            }
            
            if dream.isLucid{
                CustomIconButton(
                    icon: Image.lucidIcon,
                    iconSize: .medium,
                    isActive: filterObserver.filters.contains(FilterViewModel(filter: .isLucid(true)))
                )
            }
            
            if dream.isNightmare{
                CustomIconButton(
                    icon: Image.nightmareIcon,
                    iconSize: .medium,
                    isActive: filterObserver.filters.contains(FilterViewModel(filter: .isNightmare(true)))
                )
            }
        }
    }
}


private struct ListItemDate : View{
    let text : String
    var body : some View{
        Text(text)
            .frame(maxWidth : .infinity, alignment: .center)
            .font(.primarySmall)
            .foregroundColor(.main2)
    }
}

private struct ListItemTitle : View{
    let text : String
    
    var body : some View{
        Text(text)
            .foregroundColor(.main1)
            .font(.primaryLarge)
            .lineLimit(2)
    }
}

private struct ListItemText : View{
    let text : String
    
    var body : some View{
        Text(text)
            .foregroundColor(.main1)
            .font(.primaryRegular)
            .lineLimit(4)
            .lineSpacing(5)
    }
}

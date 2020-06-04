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
            
            dateView
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, .extraSmall)

            
            titleView
            
            if !dream.tags.isEmpty{
                tags
                    .padding(.vertical, .extraSmall)
            }
        
            textView
            
            Spacer()

            details
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal,.medium)
        .padding(.bottom, .medium)
        .padding(.top,.small)
        .background(Color.background1)
        .cornerRadius(30)
        .primaryShadow()
        .onTapGesture {
            self.showDetail = true
        }
    }
    
    // MARK: - HELPER VIEWS
    
    private var naviagationLink : some View{
        NavigationLink(destination: LazyView(DreamDetailView(dream: self.dream)), isActive: $showDetail){
            EmptyView()
        }.hidden()
    }
    
    private var details : some View{
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
    
    private var tags : some View{
        let tags = self.dream.tags.sorted { (tag1, tag2) -> Bool in
            let isFilter1 = filterObserver.filters.contains(FilterViewModel(filter: .tag(tag1)))
            let isFilter2 = filterObserver.filters.contains(FilterViewModel(filter: .tag(tag2)))
            
            if isFilter1 && !isFilter2{
                return true
            }
            return false
        }
        
        return HStack{
            ForEach(tags.prefix(3)){ tag in
                TagView(
                    tag: tag,
                    isActive: self.filterObserver.filters.contains(FilterViewModel(filter: .tag(tag)))
                )
            }
        }
    }
    
    private var seperator : some View{
        Rectangle()
            .foregroundColor(Color.main1)
            .frame(maxWidth :.infinity)
            .frame(height: 1)
            .opacity(0.1)
    }
    
    private var titleView: some View{
        Text(dream.title)
            .font(.primaryLarge)
            .foregroundColor(.main1)
            .lineLimit(2)
    }
    
    private var textView : some View {
        let textToShow = dream.text.replacingOccurrences(of: "\n", with: "")
        return Text(textToShow)
            .foregroundColor(.main1)
            .lineSpacing(.extraSmall)
            .frame(maxHeight: 100)
    }
    
    private var dateView : some View{
        Text(dream.wrapperDateString)
            .font(.primarySmall)
            .foregroundColor(.main2)
    }
}

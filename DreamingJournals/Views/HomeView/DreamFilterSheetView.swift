//
//  DreamFilterSheetView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 13/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import Combine
struct DreamFilterSheetView: View {
    @EnvironmentObject var theme : Theme
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var tags : FetchedResults<Tag>
    @EnvironmentObject var filterObserver : FilterObserver

    var allTags : [TagViewModel]{
        return self.tags.map({TagViewModel(tag: $0)})
    }
    
    var availableFilters : [TagViewModel]{
        var filters : [TagViewModel] = []
        for filter in allTags{
            if !filters.contains(where: {filter.text == $0.text}) && !filterObserver.tagFilters.contains(where: {filter.text == $0.text}){
                filters.append(filter)
            }
        }
        return filters
    }
    
    var activeFilters : [TagViewModel]{
        return filterObserver.tagFilters
    }
    
    var body: some View {
        return
            GeometryReader{ geo in
                ZStack(alignment:.top){
                    self.theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
                    ScrollView{
                        VStack(alignment: .leading){
                            
                            self.topBarView
                            
                            self.isBookmarkedFilterView
                                .padding(.horizontal, self.theme.mediumPadding)
                            
                            AvailableFilters(tags: self.availableFilters)
                                .padding(.horizontal, self.theme.mediumPadding)
                                .frame(width : geo.size.width)
                            
                            ActiveFilters(tags: self.activeFilters)
                                .padding(.horizontal, self.theme.mediumPadding)
                                .frame(width : geo.size.width)
                            
                        }
                        .padding(.leading, self.theme.mediumPadding)
                        .padding(.bottom, self.theme.smallPadding)
                    }
                }
        }
    }
    
    private var seperatorView : some View{
        Rectangle()
            .frame(height: 1)
            .foregroundColor(theme.passiveDarkColor)
    }
    
    private var isBookmarkedFilterView : some View{
        Toggle(isOn: self.$filterObserver.showOnlyFave){
            Text("Favorite only").font(theme.primaryLargeFont).foregroundColor(theme.textTitleColor)
        }
    }
    
    private var topBarView : some View{
        HStack(alignment:.center, spacing: theme.mediumPadding){
            titleView
            Spacer()
            closeButtonView
        }.padding(.horizontal, theme.mediumPadding)
            .padding(.top, theme.mediumPadding)
    }
    
    private var titleView : some View{
        Text("Filters")
            .font(theme.secundaryLargeFont)
            .foregroundColor(theme.textTitleColor)
    }
    
    private var closeButtonView : some View{
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }){
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width : theme.largePadding, height: theme.largePadding)
                .foregroundColor(theme.passiveLightColor)
        }
    }
}

// MARK: - Active Filters

private struct ActiveFilters : View {
    let tags : [TagViewModel]
    @EnvironmentObject var filterObserver : FilterObserver
    
    var body: some View{
        CollectionView(data: tags, animate: true) { (tag : TagViewModel) in
            TagView(tag: tag)
                .onTapGesture {
                    let index = self.filterObserver.tagFilters.firstIndex(of: tag)!
                    self.filterObserver.tagFilters.remove(at: index)
            }
        }
    }
}

// MARK: - Available Filters

private struct AvailableFilters : View {
    let tags : [TagViewModel]
    @EnvironmentObject var filterObserver : FilterObserver
    
    var body: some View{
        CollectionView(data: tags, animate: true) { (tag : TagViewModel) in
            TagView(tag: tag).onTapGesture {
                self.filterObserver.tagFilters.append(tag)
            }
        }
    }
}



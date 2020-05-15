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
                        VStack(alignment: .leading, spacing: 0){
                            
                            self.topBarView
                                .padding(.horizontal, self.theme.mediumPadding)
                                .padding(.top, self.theme.mediumPadding)
                            
                            ActiveFilters(tags: self.filterObserver.tagFilters)
                                .padding(.horizontal, self.theme.mediumPadding)
                                .padding(.top,self.theme.smallPadding)
                                .frame(minWidth : geo.size.width, minHeight: 200)
                            
                            self.seperatorView
                            
                            AvailableFilters(tags: self.availableFilters)
                                .padding(.horizontal, self.theme.mediumPadding)
                                .padding(.top, self.theme.mediumPadding)
                                .frame(width : geo.size.width)
                        }
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
            EmptyView()
        }
    }
    
    private var topBarView : some View{
        HStack(alignment:.center, spacing: theme.mediumPadding){
            titleView
            Spacer()
            isBookmarkedFilterView
            closeButtonView
        }
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
    @EnvironmentObject var theme : Theme

    var body: some View{
        ZStack(alignment: .center){
            if self.tags.isEmpty{
                self.placeHolderView
            }else{
                VStack{
                    CollectionView(data: tags, animate: true) { (tag : TagViewModel) in
                        TagView(tag: tag)
                            .onTapGesture {
                                let index = self.filterObserver.tagFilters.firstIndex(of: tag)!
                                self.filterObserver.tagFilters.remove(at: index)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    private var placeHolderView : some View {
        Text("No Active Filters")
            .foregroundColor(theme.textTitleColor)
            .opacity(0.5)
            .offset(x: 0, y: -theme.smallPadding)
    }
}

// MARK: - Available Filters

private struct AvailableFilters : View {
    let tags : [TagViewModel]
    @EnvironmentObject var filterObserver : FilterObserver
    @EnvironmentObject var theme : Theme
    
    
    var availableFilters : [TagViewModel]{
          var filters : [TagViewModel] = []
          for filter in tags{
              if !filters.contains(where: {filter.text == $0.text}) && !filterObserver.tagFilters.contains(where: {filter.text == $0.text}){
                  filters.append(filter)
              }
          }
          return filters
      }

    var body: some View{
        VStack(alignment: .leading){
            title
            CollectionView(data: tags, animate: true) { (tag : TagViewModel) in
                TagView(tag: tag).onTapGesture {
                    self.filterObserver.tagFilters.append(tag)
                }
            }
        }
    }
    
    private var title : some View{
        Text("Available Filters")
            .foregroundColor(theme.textTitleColor)
            .font(theme.primaryLargeFont)
    }
}



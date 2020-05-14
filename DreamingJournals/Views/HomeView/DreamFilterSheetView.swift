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
    
    var body: some View {
        return ZStack(alignment:.top){
            theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(alignment: .leading){
                    
                    topBarView
                    
                    isBookmarkedFilterView
                        .padding(.horizontal, theme.mediumPadding)
                    
                    ActiveFilters(filterObserver: filterObserver)
                        .padding(.horizontal, theme.mediumPadding)
                    
                    seperatorView
                    
                    AvailableFilters(tags: Array(self.tags), filterObserver: filterObserver)
                        .padding(.leading, theme.mediumPadding)
                    
                }
                .padding(.leading, theme.mediumPadding)
                .padding(.bottom, theme.smallPadding)
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
    @ObservedObject var filterObserver : FilterObserver
    @EnvironmentObject var theme : Theme
    var body: some View{
        ZStack(alignment: filterObserver.tagFilters.isEmpty ?  .center : .topLeading){
            Color.clear
            if filterObserver.tagFilters.isEmpty{
                placeHolderView()
            }else{
                FilterCollectionView($filterObserver.tagFilters, action: onItemPress)
            }
        }.frame(minHeight : 200)
    }
    
    private func onItemPress(tagViewModel : TagViewModel){
        let index = self.filterObserver.tagFilters.firstIndex(of: tagViewModel)!
        self.filterObserver.tagFilters.remove(at: index)
    }
    
    private func placeHolderView() -> some View {
        Text("No Active Filters")
            .foregroundColor(theme.textTitleColor)
            .opacity(0.5)
            .offset(x: 0, y: -theme.smallPadding)
    }
}

// MARK: - Available Filters

private struct AvailableFilters : View {
    @State var cancellableSet: Set<AnyCancellable> = []
    @State var availableFilters : [TagViewModel] = []
    @ObservedObject var filterObserver : FilterObserver
    let allFilters : [TagViewModel]
    
    init(tags : [Tag], filterObserver : FilterObserver) {
        self.filterObserver = filterObserver
        self.allFilters = tags.map({TagViewModel(tag: $0)})
    }
    
    var body: some View{
        FilterCollectionView(self.$availableFilters){ tag in
            let index = self.availableFilters.firstIndex(of: tag)!
            self.availableFilters.remove(at: index)
            self.filterObserver.tagFilters.append(tag)
        }.onAppear(perform: setupFilterListener)
    }
    
    private func setupFilterListener(){
        self.filterObserver.$tagFilters.sink { tags in
            self.availableFilters = []
            for filter in self.allFilters{
                if !self.availableFilters.contains(where: {filter.text == $0.text}){
                    if !tags.contains(where: {filter.text == $0.text}){
                        self.availableFilters.append(filter)
                    }
                }
            }
        }.store(in: &self.cancellableSet)
    }
}

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
                            
                            ActiveFilters()
                                .padding(.horizontal, self.theme.mediumPadding)
                                .padding(.top,self.theme.smallPadding)
                                .frame(minWidth : geo.size.width, minHeight: 200)
                            
                            self.seperatorView
                            
                            AvailableFilters()
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
    
    private var topBarView : some View{
        HStack(alignment:.center, spacing: theme.mediumPadding){
            titleView
            Spacer()
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
    @EnvironmentObject var filterObserver : FilterObserver
    @EnvironmentObject var theme : Theme
    
    var body: some View{
        ZStack(alignment: .center){
            if self.filterObserver.tagFilters.isEmpty{
                self.placeHolderView
            }else{
                VStack{
                    CollectionView(data: filterObserver.tagFilters, animate: true) { (tag : TagViewModel) in
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
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var filterObserver : FilterObserver
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var fetchedTags : FetchedResults<Tag>
    @State var availableFilters : [TagViewModel] = []
    var tags : [TagViewModel]{fetchedTags.map({TagViewModel(tag: $0)})}
    
    var body: some View{
        CollectionView(data: availableFilters){(tag : TagViewModel) in
            TagView(tag: tag)
                .onTapGesture {self.onItemTap(tag)}
        }.onReceive(filterObserver.$tagFilters) { _ in
            self.onUpdate()
        }
    }
    
    private func onUpdate(){
        self.availableFilters = []
        for filter in self.tags{
            if !self.availableFilters.contains(where: {filter.text == $0.text}){
                if !self.filterObserver.tagFilters.contains(where: {filter.text == $0.text}) {
                    self.availableFilters.append(filter)
                }
            }
        }
    }
    
    private func onItemTap(_ tag : TagViewModel){
        let index = self.availableFilters.firstIndex(of: tag)!
        self.availableFilters.remove(at: index)
        self.filterObserver.tagFilters.append(tag)
    }
    
    private var title : some View{
        Text("Available Filters")
            .foregroundColor(theme.textTitleColor)
            .font(theme.primaryLargeFont)
    }
}



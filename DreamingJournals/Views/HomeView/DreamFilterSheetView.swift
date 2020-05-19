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
                            self.subTitleView

                            AvailableFilters()
                                .padding(.horizontal, self.theme.mediumPadding)
                                .padding(.top, self.theme.smallPadding)
                                .frame(width : geo.size.width)
                        }
                    }
                }
        }
    }
    
    private var seperatorView : some View{
        Rectangle()
            .frame(height: 1)
            .foregroundColor(theme.secondaryBackgroundColor)
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
            .foregroundColor(theme.primaryTextColor)
    }
    
    private var subTitleView : some View{
         Text("Available Filters")
             .font(theme.primaryLargeFont)
             .foregroundColor(theme.primaryTextColor)
             .padding(.leading , theme.mediumPadding)
             .padding(.top, theme.mediumPadding)
     }
    
    private var closeButtonView : some View{
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            mediumFeedback()
        }){
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width : theme.largePadding, height: theme.largePadding)
                .foregroundColor(theme.secondaryAccentColor)
        }
    }
}

// MARK: - Available Filters

struct AvailableFilters : View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var filterObserver : FilterObserver
    
    
    var body: some View{
        CollectionView(data: filterObserver.availableFilters){(filter : FilterViewModel) in
            FilterView(filter: filter)
                .onTapGesture {
                    mediumFeedback()
                    withAnimation(){
                        self.filterObserver.filters.append(filter)
                    }
            }
        }
    }
}

// MARK: - Active Filters

private struct ActiveFilters : View {
    @EnvironmentObject var filterObserver : FilterObserver
    @EnvironmentObject var theme : Theme
    
    var body: some View{
        VStack{
            ZStack(alignment: .center){
                if self.filterObserver.filters.isEmpty{
                    self.placeHolderView
                }else{
                    VStack{
                    CollectionView(data: filterObserver.filters){ (filterViewModel : FilterViewModel) in
                        FilterView(filter: filterViewModel)
                            .onTapGesture {
                                mediumFeedback()
                                withAnimation(){
                                    let index = self.filterObserver.filters.firstIndex(where: {$0.id == filterViewModel.id})!
                                    self.filterObserver.filters.remove(at: index)
                                }
                        }
                    }
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var placeHolderView : some View {
        Text("No Active Filters")
            .foregroundColor(theme.placeHolderTextColor)
            .opacity(0.5)
            .offset(x: 0, y: -theme.smallPadding)
    }
}

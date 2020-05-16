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
                    self.theme.backgroundColor.edgesIgnoringSafeArea(.all)
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
            .foregroundColor(theme.textColor)
    }
    
    private var closeButtonView : some View{
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }){
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width : theme.largePadding, height: theme.largePadding)
                .foregroundColor(theme.secondaryColor)
        }
    }
}

// MARK: - Available Filters

struct AvailableFilters : View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var filterObserver : FilterObserver
    
    
    var body: some View{
        CollectionView(data: filterObserver.availableFilters, animate: true){(filter : FilterViewModel) in
            FilterView(filter: filter)
                .onTapGesture {
                    self.filterObserver.filters.append(filter)
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
                    CollectionView(data: filterObserver.filters, animate: true){ (filterViewModel : FilterViewModel) in
                        FilterView(filter: filterViewModel)
                            .onTapGesture {
                                let index = self.filterObserver.filters.firstIndex(where: {$0.id == filterViewModel.id})!
                                self.filterObserver.filters.remove(at: index)
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
            .foregroundColor(theme.textColor)
            .opacity(0.5)
            .offset(x: 0, y: -theme.smallPadding)
    }
}

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
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        return
            GeometryReader{ geo in
                ZStack(alignment:.top){
                    Color.background1.edgesIgnoringSafeArea(.all)
                    ScrollView{
                        VStack(alignment: .leading, spacing: 0){
                            
                            self.topBarView
                                .padding(.horizontal, .medium)
                                .padding(.top, .medium)
                            
                            ActiveFilters()
                                .padding(.horizontal, .medium)
                                .padding(.top,.small)
                                .frame(minWidth : geo.size.width, minHeight: 200)
                            
                            self.seperatorView
                            self.subTitleView

                            AvailableFilters()
                                .padding(.horizontal, .medium)
                                .padding(.top, .small)
                                .frame(width : geo.size.width)
                        }
                    }
                }
        }
    }
    
    private var seperatorView : some View{
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.background2)
    }
    
    private var topBarView : some View{
        HStack(alignment:.center, spacing: .medium){
            titleView
            Spacer()
            closeButtonView
        }
    }
    
    private var titleView : some View{
        Text("Filters")
            .font(Font.secondaryLarge)
            .foregroundColor(.main1)
    }
    
    private var subTitleView : some View{
         Text("Available Filters")
             .font(Font.primaryLarge)             .foregroundColor(.main1)
             .padding(.leading , .medium)
             .padding(.top, .medium)
     }
    
    private var closeButtonView : some View{
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            mediumFeedback()
        }){
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width : .large, height: .large)
                .foregroundColor(.main1)
        }
    }
}

// MARK: - Available Filters

struct AvailableFilters : View {
    
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
            .foregroundColor(.main2)
            .opacity(0.5)
            .offset(x: 0, y: -.small)
    }
}

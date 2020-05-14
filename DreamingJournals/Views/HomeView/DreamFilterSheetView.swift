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
              
                    HStack(alignment:.center, spacing: theme.mediumPadding){
                        Text("Filters").font(theme.secundaryLargeFont).foregroundColor(theme.textTitleColor)
                        Spacer()
                        Button(action:{
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width : theme.largePadding, height: theme.largePadding)
                                .foregroundColor(theme.passiveLightColor)
                        }
                    }.padding(.horizontal, theme.mediumPadding)
                        .padding(.top, theme.mediumPadding)
                    
                    Toggle(isOn: self.$filterObserver.showOnlyFave){
                                      Text("Favorite only").font(theme.primaryLargeFont).foregroundColor(theme.textTitleColor)
                                  }
                                  .padding(.horizontal, theme.mediumPadding)
                    ZStack(alignment: filterObserver.tagFilters.isEmpty ?  .center : .topLeading){
                        Color.clear
                        if filterObserver.tagFilters.isEmpty{
                            Text("No Active Filters")
                                .foregroundColor(theme.textTitleColor)
                                .opacity(0.5)
                                .offset(x: 0, y: -theme.smallPadding)
                        }else{
                            ActiveFilters(filterObserver: self.filterObserver)
                        }
                    }
                    .padding(.horizontal, theme.mediumPadding)
                    .frame(minHeight : 200)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(theme.passiveDarkColor)
                    HStack{Text("Available Filters")
                        .font(theme.primaryLargeFont)
                        .foregroundColor(theme.textTitleColor)
                    }.padding(.leading, theme.mediumPadding)
                        .padding(.bottom, theme.smallPadding)
                    
                    AvailableFilters(tags: Array(self.tags), filterObserver: filterObserver)
                        .padding(.leading, theme.mediumPadding)
                    
                    
                }
            }
        }
    }
}

struct ActiveFilters : View {
    @ObservedObject var filterObserver : FilterObserver
    
    var body: some View{
        FilterCollectionView(self.$filterObserver.tagFilters){ tag in
            let index = self.filterObserver.tagFilters.firstIndex(of: tag)!
            self.filterObserver.tagFilters.remove(at: index)
        }
    }
}



struct AvailableFilters : View {
    @State var availableFilters : [TagViewModel] = []
    @ObservedObject var filterObserver : FilterObserver
    @State var cancellableSet: Set<AnyCancellable> = []
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
        }.onAppear{
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
}

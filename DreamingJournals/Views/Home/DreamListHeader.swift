//
//  DreamListHeader.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct ListHeader : View {
    @EnvironmentObject var filterObserver : FilterObserver
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    @State var showFilterSheet = false
    
    let lucidFilter = FilterViewModel(filter: .lucid(true))
    let nightmareFilter = FilterViewModel(filter: .nightmare(true))
    let bookmarkedFilter = FilterViewModel(filter: .bookmarked(true))
    
    var isLucidFilterActive : Bool {
        isFilterActive(filter: lucidFilter)
    }
    
    var isNightmareFilterActive : Bool {
        isFilterActive(filter: nightmareFilter)
    }
    
    var isBookmarkedFilterActive : Bool {
        isFilterActive(filter: bookmarkedFilter)
    }
    
    
    var body: some View{
        return
            ZStack(alignment:.bottom){
                
                Image("art1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth : UIScreen.main.bounds.width)
                    .background(
                        LinearGradient(gradient: .skyGradient(isDarkMode: colorScheme == .dark), startPoint: .bottom, endPoint: .top)
                )
                
                VStack(alignment: .leading, spacing: 0){
                    
                    HStack(spacing: 0){
                        title.padding(.leading, .medium)
                        Spacer()
                    }.offset(y : -.extraLarge)
                    HStack{
                        
                        FilterButton(iconName: "heart", isActive: isBookmarkedFilterActive, filterText: "Liked") {
                            self.onFilterPress(filter: self.bookmarkedFilter)
                        }
                        
                        Spacer()
                        
                        FilterButton(iconName: "eye", isActive: isLucidFilterActive, filterText: "Lucid") {
                            self.onFilterPress(filter: self.lucidFilter)
                        }
                        
                        
                        Spacer()
                        
                        FilterButton(iconName: "tropicalstorm", isActive: isNightmareFilterActive, filterText: "Nightmare") {
                            self.onFilterPress(filter: self.nightmareFilter)
                        }
                        
                        Spacer()
                        
                        FilterButton(iconName: "tag", isActive: false, filterText: "tags") {
                            self.showFilterSheet = true
                        }.sheet(isPresented: self.$showFilterSheet){
                            DreamFilterSheetView()
                                .environmentObject(self.filterObserver)
                                .environment(\.managedObjectContext, self.moc)
                        }
                    }.padding(.horizontal, .medium)
                }
            }.padding(.bottom, .medium)
    }
    
    func onFilterPress(filter: FilterViewModel){
        if let index = self.getFilterIndex(filter: filter){
            self.filterObserver.filters.remove(at: index)
        }else{
            self.filterObserver.filters.append(filter)
        }
    }
    
    func getFilterIndex(filter : FilterViewModel) -> Int?{
        if let index = self.filterObserver.filters.firstIndex(where: { (checkFilter : FilterViewModel) in
            checkFilter.filter.areEqual(filter: filter.filter)
        }){
            return index
        }
        return nil
    }
    
    func isFilterActive(filter : FilterViewModel) -> Bool{
        if getFilterIndex(filter: filter) == nil{
            return false
        }else{
            return true
        }
    }
    
    //MARK: - HELPER VIEWS
    
    private var title : some View{
        Text("Dreams")
            .font(.system(size: 60, weight: .regular, design: .serif))
            .foregroundColor(.main1)
    }
}

struct FilterButton : View{
    let isActive : Bool
    let action : () -> ()
    let iconName : String
    let filterText : String
    
    init(iconName : String, isActive: Bool,filterText: String, action : @escaping () -> ()) {
        self.action = action
        self.iconName = iconName
        self.isActive = isActive
        self.filterText = filterText
    }
    
    var body: some View{
        VStack {
            Image(systemName: iconName)
                .imageScale(.large)
                .foregroundColor(isActive ? .accent1 : .main1 )
                .shadow(color: isActive ? Color.accent1.opacity(0.3) : .clear, radius: 10, x: 0, y: 0)
                .frame(width: .extraLarge + 20, height: .extraLarge + 20)
                .background(Color.background3)
                .cornerRadius(10)
                .onTapGesture(perform: action)
                .primaryShadow()
            
            Text(filterText).font(.caption).foregroundColor(Color.main1.opacity(0.7))
        }
    }
}

struct DreamListHeader_Previews: PreviewProvider {
    static var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            VStack {
                ListHeader()
                    .environmentObject(FilterObserver())
                    .environment(\.managedObjectContext, context)
                Spacer()
            }
        }
    }
}

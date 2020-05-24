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
    @State var showFilterSheet = false

    let lucidFilter = FilterViewModel(filter: .lucid(true))
    let nightmareFilter = FilterViewModel(filter: .nightmare(true))
    let bookmarkedFilter = FilterViewModel(filter: .bookmarked(true))
    
    var isLucidFilterActive : Bool {
        isFilterActive(filter: lucidFilter)
    }
    
    var isNightmareFilterActive : Bool {
        isFilterActive(filter: lucidFilter)
    }
    
    var isBookmarkedFilterActive : Bool {
        isFilterActive(filter: lucidFilter)
    }

    
    var body: some View{
        return
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 0){
                    title.padding(.leading, .extraSmall)
                    Spacer()
                }
                HStack{
                    
                    FilterButton(iconName: "heart", isActive: isBookmarkedFilterActive) {
                        self.onFilterPress(filter: self.bookmarkedFilter)
                    }
                    
                    Spacer()
                    
                    FilterButton(iconName: "eye", isActive: isLucidFilterActive) {
                        self.onFilterPress(filter: self.lucidFilter)
                    }
                    
                    
                    Spacer()
                    
                    FilterButton(iconName: "tropicalstorm", isActive: isNightmareFilterActive) {
                        self.onFilterPress(filter: self.nightmareFilter)
                    }
                    
                    Spacer()
                    
                    FilterButton(iconName: "tag", isActive: false) {
                        self.showFilterSheet = true
                    }.sheet(isPresented: self.$showFilterSheet){
                        DreamFilterSheetView()
                            .environmentObject(self.filterObserver)
                            .environment(\.managedObjectContext, self.moc)
                    }
                }.padding(.horizontal, .small)
        }
        
        
        
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
            .font(Font.secondaryLarge)
            .foregroundColor(.main1)
    }
}

struct FilterButton : View{
    let isActive : Bool
    let action : () -> ()
    let iconName : String
    
    init(iconName : String, isActive: Bool, action : @escaping () -> ()) {
        self.action = action
        self.iconName = iconName
        self.isActive = isActive
    }
    
    var body: some View{
        Image(systemName: iconName)
            .imageScale(.large)
            .foregroundColor(.main1)
            .frame(width: .extraLarge + 20, height: .extraLarge + 20)
            .background(Color.background1)
            .cornerRadius(10)
            .secondaryShadow()
            .onTapGesture(perform: action)
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

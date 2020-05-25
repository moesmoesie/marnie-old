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
    
    var body: some View{
        let headerHeight = UIScreen.main.bounds.height / 2
        
        return
            ZStack(alignment:.bottom){
                Sky(mainHeight: headerHeight)
                Mountains(height: headerHeight)
                VStack(alignment: .leading, spacing: 0){
                    self.title
                        .padding(.leading, .medium)
                        .padding(.bottom, .extraLarge)
                    
                    self.filterButtons
                        .padding(.horizontal, .medium)
                }
            }.frame(height  : headerHeight, alignment: .bottom)
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
    
    //MARK: - HELPER VIEWS
    
    private var title : some View{
        Text("Dreams")
            .font(.system(size: 60, weight: .regular, design: .serif))
            .foregroundColor(.main1)
    }
    
    private var filterButtons : some View{
        HStack{
            
            FilterButton(
                iconName: "heart",
                isActive: filterObserver.isFilterTypeActive(filter: bookmarkedFilter),
                filterText: "Liked") {
                self.onFilterPress(filter: self.bookmarkedFilter)
            }
            
            Spacer()
            
            FilterButton(
                iconName: "eye",
                isActive: filterObserver.isFilterTypeActive(filter: lucidFilter),
                filterText: "Lucid") {
                self.onFilterPress(filter: self.lucidFilter)
            }
            
            
            Spacer()
            
            FilterButton(
                iconName: "tropicalstorm",
                isActive: filterObserver.isFilterTypeActive(filter: nightmareFilter),
                filterText: "Nightmare") {
                self.onFilterPress(filter: self.nightmareFilter)
            }
            
            Spacer()
            
            FilterButton(
                iconName: "tag",
                isActive: filterObserver.isFilterTypeActive(filter: FilterViewModel(filter: .tag(TagViewModel(text: "")))),
                filterText: "tags") {
                self.showFilterSheet = true
            }.sheet(isPresented: self.$showFilterSheet){
                DreamFilterSheetView()
                    .environmentObject(self.filterObserver)
                    .environment(\.managedObjectContext, self.moc)
            }
        }
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
            CustomIconButton(iconName: iconName, iconSize: .large,isActive: isActive, action: action)
            Text(filterText).font(.caption).foregroundColor(isActive ? Color.main1 : Color.main1.opacity(0.7))
        }
    }
}

struct Sky : View {
    @Environment(\.colorScheme) var colorScheme
    let mainHeight : CGFloat
    var body: some View{
        let totalHeight = mainHeight * 10
        let isDarkmode = colorScheme == .dark
        return LinearGradient(
            gradient: Gradient.skyGradient(darkMode: isDarkmode,
                                            totalHeight: totalHeight,
                                            mainHeight: mainHeight),
            startPoint: .bottom,
            endPoint: .top)
            .frame(height : totalHeight)
    }
}

struct Mountains : View {
    let height : CGFloat
    var body: some View{
        Image("art1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth:UIScreen.main.bounds.width)
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

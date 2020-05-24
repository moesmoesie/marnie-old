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
    let lucidFilter = FilterViewModel(filter: .lucid(true))
    let nightmareFilter = FilterViewModel(filter: .nightmare(true))
    let bookmarkedFilter = FilterViewModel(filter: .bookmarked(true))
    @State var showFilterSheet = false
    
    var body: some View{
        return
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 0){
                    title.padding(.leading, .extraSmall)
                    Spacer()
                }
                HStack{
                    
                    FilterButton(iconName: "heart") {
                                       if let index = self.getFilterIndex(filter: self.bookmarkedFilter){
                                           self.filterObserver.filters.remove(at: index)
                                       }else{
                                           self.filterObserver.filters.append(self.bookmarkedFilter)
                                       }
                                   }
                    
                    Spacer()
                    
                    FilterButton(iconName: "eye") {
                        if let index = self.getFilterIndex(filter: self.lucidFilter){
                            self.filterObserver.filters.remove(at: index)
                        }else{
                            self.filterObserver.filters.append(self.lucidFilter)
                        }
                    }
                                
                    
                    Spacer()
                    
                    FilterButton(iconName: "tropicalstorm") {
                        if let index = self.getFilterIndex(filter: self.nightmareFilter){
                            self.filterObserver.filters.remove(at: index)
                        }else{
                            self.filterObserver.filters.append(self.nightmareFilter)
                        }
                    }
                    
                    Spacer()
                    
                    FilterButton(iconName: "tag") {
                        self.showFilterSheet = true
                    }.sheet(isPresented: self.$showFilterSheet){
                        DreamFilterSheetView()
                            .environmentObject(self.filterObserver)
                            .environment(\.managedObjectContext, self.moc)
                    }
                }.padding(.horizontal, .small)
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
            .font(Font.secondaryLarge)
            .foregroundColor(.main1)
    }
}

struct FilterButton : View{
    let action : () -> ()
    let iconName : String
    
    init(iconName : String, action : @escaping () -> ()) {
        self.action = action
        self.iconName = iconName
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

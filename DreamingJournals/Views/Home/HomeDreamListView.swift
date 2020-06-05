//
//  DreamListView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct HomeDreamListView : View {
    @EnvironmentObject var fetchObserver : FetchObserver
    @EnvironmentObject var filterObserver : FilterObserver
    @Environment(\.managedObjectContext) var managedObjectContext

    var dreams: FetchedResults<Dream>
    
    var body: some View{
        return List{
            HomeDreamListHeaderView(hasDreams: !dreams.isEmpty)
                .listRowInsets(EdgeInsets())
                .padding(.bottom, .medium)
            ForEach(0..<dreams.count, id : \.self){ (index : Int) in
                HomeDreamListItemView(dream: self.dreams[index])
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, .medium / 2)
                    .padding(.horizontal, .medium)
                    .onAppear{
                        self.onDreamAppear(index)
                    }
            }
            Spacer(minLength: .navigationBarHeight * 1.5)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: onDreamListAppear)
    }
    
    func onDreamListAppear(){
        if Dream.dreamCount(context: managedObjectContext) == 0{
            self.filterObserver.filters.removeAll()
        }
        removeTableViewBackground()
    }
    
    func onDreamAppear(_ index : Int){
        if index + 1 == self.fetchObserver.fetchlimit{
            DispatchQueue.main.async {
                self.fetchObserver.incrementLimit()
            }
        }
    }
}

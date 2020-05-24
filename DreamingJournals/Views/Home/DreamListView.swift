//
//  DreamListView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct DreamList : View {
    var dreams: [DreamViewModel]
    var dreamListItems : [DreamListItemModel]{
        dreams.map({DreamListItemModel($0)})
    }
    
    var body: some View{
        return List{
            ListHeader()
            ForEach(dreamListItems){ (dream : DreamListItemModel) in
                DreamListItemView(dreamListItem: dream)
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, .medium / 2)
                    .padding(.horizontal, .medium)
            }
        }
    }
}


struct DreamListItemModel : Identifiable {
    var id = UUID()
    var showDream = false
    var dream : DreamViewModel
    var details : [Self.Detail]
    
    init(_ dream : DreamViewModel) {
        self.dream = dream
        self.details = []
        if dream.isBookmarked{
            self.details.append(Detail(icon: Image(systemName: "heart")))
        }
        
        self.details.append(Detail(icon: Image(systemName: "eye")))
    }
    
    struct Detail : Identifiable{
        var id = UUID()
        var icon : Image
    }
}

struct DreamListView_Previews: PreviewProvider {
    static var context = InMemoryCoreDataStack().managedObjectContext
    static var previews: some View {
        removeTableViewBackground()
        return ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            DreamList(dreams: sampleData)
        }.environment(\.managedObjectContext, context)
        .environmentObject(FilterObserver())
    }
}

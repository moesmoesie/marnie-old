//
//  DreamListView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamList : View {
    var dreams: [DreamViewModel]
    
    var body: some View{
        List{
            ListHeader()
                .listRowInsets(EdgeInsets())
                .padding(.leading, .medium)
                .padding(.bottom, .small)
            
            ForEach(self.dreams.map({DreamListItemModel($0)})){ (dream : DreamListItemModel) in
                DreamListItem(dreamListItem: dream)
                    .listRowInsets(EdgeInsets())
                    .padding(.bottom, .medium)
                    .padding(.horizontal, .medium)
            }
            Spacer().frame(height : .large + getBottomSaveArea())
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

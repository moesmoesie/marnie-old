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
    var dreams: [Dream]
    
    var body: some View{
        return List{
            ListHeader()
                .listRowInsets(EdgeInsets())
                .padding(.bottom, .medium)
            ForEach(dreams, id : \.self){ (dream : Dream) in
                DreamListItemView(dream: dream)
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, .medium / 2)
                    .padding(.horizontal, .medium)
            }
            Spacer(minLength: .navigationBarHeight * 1.5)
            }
        .edgesIgnoringSafeArea(.all)
    }
}


struct DreamListItemModel {
    var showDream = false
    var details : [Self.Detail]
    let dream : DreamViewModel
    
    init(_ dream : Dream) {
        self.dream = DreamViewModel(dream: dream)
        self.details = []
           if dream.isBookmarked{
            self.details.append(Detail(icon: "heart"))
        }
        
        if dream.isLucid{
            self.details.append(Detail(icon: "eye"))
        }
        
        if dream.isNightmare{
            self.details.append(Detail(icon: "tropicalstorm"))
        }
    }
    
    struct Detail : Identifiable{
        var id = UUID()
        var icon : String
    }
}

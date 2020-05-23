//
//  FilterView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 15/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct FilterView : View {
    let filter : FilterViewModel
    
    var body: some View{
       content()
    }
    
    func content() -> some View{
        switch filter.filter {
        case .bookmarked(let isBookmarked):
            return AnyView(BookmarkedFilterView(isBookmarked: isBookmarked))
        case .tag(let tag):
            return AnyView(TagView(tag: tag))
        }
    }
}

struct BookmarkedFilterView: View {
     
     let isBookmarked : Bool
     var body: some View {
        Image(systemName: "heart.fill").foregroundColor(.accent1)
        .offset(x: 0, y: 3)
     }
 }

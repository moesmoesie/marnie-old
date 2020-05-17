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
     @EnvironmentObject var theme : Theme
     let isBookmarked : Bool
     var body: some View {
        Text(isBookmarked ? "Bookmarked" : "Not Bookmarked")
             .font(theme.secundaryRegularFont)
             .bold()
             .padding(.horizontal)
             .padding(.vertical,2)
             .background(theme.secondaryAccentColor)
             .foregroundColor(theme.primaryTextColor)
             .clipShape(Capsule())
     }
 }

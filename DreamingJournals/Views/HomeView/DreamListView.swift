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
    @EnvironmentObject var theme : Theme
    
    var body: some View{
        List{
            ListHeader()
                .listRowInsets(EdgeInsets())
                .padding(.horizontal, self.theme.mediumPadding)
                .padding(.bottom, self.theme.smallPadding)
            
            ForEach(self.dreams){ (dream : DreamViewModel) in
                DreamListItem(dream: dream)
                    .listRowInsets(EdgeInsets())
                    .padding(self.theme.mediumPadding)
                    .background(self.theme.secundaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: self.theme.mediumPadding))
                    .padding(.horizontal, self.theme.mediumPadding)
                    .padding(.bottom, self.theme.mediumPadding)
            }
            Spacer().frame(height : theme.largePadding + getBottomSaveArea())
        }
    }
}

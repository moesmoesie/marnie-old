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
            
            ForEach(self.dreams){ (dream : DreamViewModel) in
                DreamListItem(dream: dream)
                    .listRowInsets(EdgeInsets())
                    .padding(.medium)
                    .background(Color.background2)
                    .clipShape(RoundedRectangle(cornerRadius: .medium))
                    .padding(.horizontal, .medium)
                    .padding(.bottom, .medium)
            }
            Spacer().frame(height : .large + getBottomSaveArea())
        }
    }
}

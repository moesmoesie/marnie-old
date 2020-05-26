//
//  Modifiers.swift
//  DreamingJournals
//
//  Created by moesmoesie on 26/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct BottomBarStyling: ViewModifier {
    func body(content: Content) -> some View {
        let isSaveArea = getBottomSaveArea()  > 0
        
        return content
            .frame(height: .navigationBarHeight)
            .frame(maxWidth : .infinity)
            .padding(.bottom, isSaveArea ? getBottomSaveArea() : .small)
            .background(Color.background1.opacity(0.98))
            .cornerRadius(.medium)
            .offset(y : isSaveArea ? getBottomSaveArea()  * 1.5 : .small)
    }
}

//
//  TagView.swift
//  DreamBook
//
//  Created by moesmoesie on 01/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct TagView: View {
    @EnvironmentObject var theme : Theme
    let tag : TagViewModel
    var body: some View {
        Text(tag.text)
            .font(theme.secundaryRegularFont)
            .bold()
            .padding(.horizontal)
            .padding(.vertical,2)
            .background(theme.primaryColor)
            .foregroundColor(theme.textColor)
            .clipShape(Capsule())
    }
}

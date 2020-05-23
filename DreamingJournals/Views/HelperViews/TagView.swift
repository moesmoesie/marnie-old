//
//  TagView.swift
//  DreamBook
//
//  Created by moesmoesie on 01/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct TagView: View {
    let tag : TagViewModel
    var body: some View {
        Text(tag.text)
            .font(.secondaryRegular)
            .bold()
            .padding(.horizontal)
            .padding(.vertical,2)
            .background(Color.accent1)
            .foregroundColor(.primary)
            .clipShape(Capsule())
    }
}

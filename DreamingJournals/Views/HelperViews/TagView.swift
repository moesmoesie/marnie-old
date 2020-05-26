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
            .lineLimit(1)
            .padding(.horizontal)
            .padding(.vertical,2)
            .background(Color.background3)
            .foregroundColor(.main1)
            .clipShape(Capsule())
            .truncationMode(.tail)
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tag: TagViewModel(text: "Hello"))
    }
}

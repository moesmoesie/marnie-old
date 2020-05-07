//
//  TagCollectionView.swift
//  DreamBook
//
//  Created by moesmoesie on 01/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct TagCollectionView: View {
    @Binding var tags : [TagViewModel]
    var body: some View {
        HStack{
            ForEach(tags){tag in
                TagView(tag: tag)
                    .padding(.trailing,2)
                    .onTapGesture {
                        let tagIndex = self.tags.firstIndex(of: tag)!
                        self.tags.remove(at: tagIndex)
                }
            }
        }
    }
}

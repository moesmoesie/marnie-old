//
//  TagCollectionView.swift
//  DreamBook
//
//  Created by moesmoesie on 01/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct TagCollectionView: View {
    @Binding var tags : [Tag]
    var body: some View {
        HStack{
            ForEach(tags, id: \.self){tag in
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

struct TagCollectionView_Previews: PreviewProvider {
    static let coreDataStack = InMemoryCoreDataStack()
    static var previews: some View {
        let tagService = TagService(managedObjectContext: coreDataStack.managedObjectContext)
        let tag = try? tagService.createTag(text: "TestTag")
        return TagCollectionView(tags: .constant([tag!]))
    }
}

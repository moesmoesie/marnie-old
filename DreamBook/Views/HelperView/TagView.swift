//
//  TagView.swift
//  DreamBook
//
//  Created by moesmoesie on 01/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct TagView: View {
    let tag : Tag
    var body: some View {
        Text(tag.wrapperText)
            .font(.caption)
            .padding(.horizontal)
            .padding(.vertical,2)
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

struct TagView_Previews: PreviewProvider {
    static let coreDataStack = InMemoryCoreDataStack()
    static var previews: some View {
        let tagService = TagService(managedObjectContext: coreDataStack.managedObjectContext)
        let tag = try? tagService.createTag(text: "TestTag")
        return TagView(tag: tag!)
    }
}

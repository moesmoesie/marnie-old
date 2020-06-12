//
//  LazyView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 27/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
struct LazyView<Content: View>: View {
    let build: () -> Content
        init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

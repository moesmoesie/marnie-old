//
//  BetterButton.swift
//  DreamingJournals
//
//  Created by moesmoesie on 19/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct BetterButton<Content: View>: View{
    let content : () -> Content
    let action : () -> ()
    let scale : CGFloat
    
    init(scale : CGFloat ,action : @escaping () -> (),content: @escaping () -> Content) {
        self.action = action
        self.content = content
        self.scale = scale
    }
    
    var body: some View {
        content()
        .overlay(
            Color.black
                .opacity(0.0001)
                .scaleEffect(scale)
            .onTapGesture {
                self.action()
            }
        )
    }
}

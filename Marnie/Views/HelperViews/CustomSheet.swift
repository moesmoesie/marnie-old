//
//  CustomSheet.swift
//  DreamingJournals
//
//  Created by moesmoesie on 07/06/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI


struct CustomSheet<Content: View>: View {
    let content : () -> Content
    let showFullScreen : Bool
    let show : Bool
    
    init(show : Bool, showFullScreen : Bool, content: @escaping () -> Content) {
        self.showFullScreen = showFullScreen
        self.content = content
        self.show = show
    }
    
    var body: some View{
        let screen = UIScreen.main.bounds
        return VStack(spacing: 0) {
            content()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .cornerRadius(30)
        .shadow(radius: 20)
        .edgesIgnoringSafeArea(.all)
        .offset(y : .extraSmall)
        .offset(y : show ? 0 : screen.height)
        .disabled(!show)
    }
}

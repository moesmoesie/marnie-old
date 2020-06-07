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
    
    init(showFullScreen : Bool, content: @escaping () -> Content) {
        self.showFullScreen = showFullScreen
        self.content = content
    }
    
    var body: some View{
        let screen = UIScreen.main.bounds
        return VStack(spacing: 0) {
            content()
            .animation(nil)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .cornerRadius(30)
        .shadow(radius: 20)
        .edgesIgnoringSafeArea(.all)
        .offset(y : .extraSmall)
        .transition(.offset(y : screen.height))
        .animation(.timingCurve(0.4, 0.8, 0.2, 1, duration : 0.7))
    }
}

//
//  DreamDetailView.swift
//  dream-book
//
//  Created by moesmoesie on 24/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailView: View {
    let dream : DreamViewModel
    
    var body: some View {
        DreamDetailContentView()
            .environmentObject(dream.getCopy())
    }
}


struct DreamDetailContentView : View {
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var keyboardObserver : KeyboardObserver

    var body: some View{
        ZStack(alignment: .bottom){
            theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: theme.smallPadding){
                DreamDetailTopBar()
                DreamDetailMainContentView()
                .padding(.horizontal, theme.mediumPadding)

            }
            .navigationBarTitle("",displayMode: .inline)
            .navigationBarHidden(true)
            
            if keyboardObserver.isKeyboardShowing{
                DreamDetailKeyboardBar()
            }
        }
    }
}



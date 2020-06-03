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
    let oldDream : OldDream
    @ObservedObject var editorObserver = EditorObserver()
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    
    init(dream : DreamViewModel) {
        self.oldDream = OldDream(dream)
        self.dream = dream.getCopy()
    }
    
    init() {
        let newDream = DreamViewModel()
        self.oldDream = OldDream(newDream)
        self.dream = newDream.getCopy()
    }
    
    var body: some View {
        DreamDetailContentView()
            .environmentObject(dream)
            .environmentObject(editorObserver)
            .environmentObject(oldDream)
            .onReceive(editorObserver.$currentMode, perform: { (mode) in
                if mode == .actionMode{
                    self.keyboardObserver.dismissKeyboard()
                }
            })
    }
}

struct DreamDetailContentView : View {
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var editorObserver : EditorObserver
    
    var body: some View{
        ZStack(alignment: .bottom){
            Color.background1.edgesIgnoringSafeArea(.all)
            VStack(spacing: .small){
                DreamDetailTopBar()
                DreamDetailMainContentView()
                    .padding(.horizontal, .medium)
            }
            
            DreamDetailBottomBar()
                .modifier(BottomBarStyling())
            DreamDetailKeyboardBar()
        }
        .navigationBarTitle("",displayMode: .inline)
        .navigationBarHidden(true)
    }
}

class OldDream : ObservableObject{
    let dream : DreamViewModel
    
    init(_ oldDream : DreamViewModel) {
        self.dream = oldDream
    }
}

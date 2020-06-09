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
    @ObservedObject var tagSuggestionObserver = TagSuggestionObserver()

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
            .environmentObject(tagSuggestionObserver)
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
            .zIndex(0)
            
            DreamDetailMainContentView()
                .padding(.horizontal, .medium)
            .zIndex(1)
            
            DreamDetailBottomBar()
                .modifier(BottomBarStyling())
            .zIndex(2)
            
            DreamDetailTopBar()
                .edgesIgnoringSafeArea(.all)
                .frame(maxHeight: .infinity, alignment: .top)
            .zIndex(3)
            
            if editorObserver.isInTagMode{
                DreamDetailTagsSheet()
                    .zIndex(4)
            }

            DreamDetailKeyboardBar()
            .zIndex(5)
        }
        .navigationBarTitle("",displayMode: .inline)
        .navigationBarHidden(true)
        .colorScheme(.dark)
    }
}

class OldDream : ObservableObject{
    let dream : DreamViewModel
    
    init(_ oldDream : DreamViewModel) {
        self.dream = oldDream
    }
}

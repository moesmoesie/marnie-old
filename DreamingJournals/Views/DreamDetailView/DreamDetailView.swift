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
    @ObservedObject var editorObserver = EditorObserver()
    @ObservedObject var suggestionTagsObserver : SuggestionTagsObserver
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    
    init(dream : DreamViewModel) {
        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.managedObjectContext
        let tagService = TagService(managedObjectContext: context)
        self.suggestionTagsObserver = SuggestionTagsObserver(allTags: tagService.getUniqueTags())
        self.dream = dream.getCopy()
    }
    
    var body: some View {
        DreamDetailContentView()
            .environmentObject(dream)
            .environmentObject(editorObserver)
            .environmentObject(suggestionTagsObserver)
            .onReceive(editorObserver.$currentMode, perform: { (mode) in
                if mode == .actionMode{
                    self.keyboardObserver.dismissKeyboard()
                }
            })
            .onReceive(editorObserver.$cursorPosition) {(position : Int) in
                var text = String(self.dream.text.prefix(position))
                if position > 100{
                    let offSet = text.index(text.endIndex, offsetBy: -100)
                    let sub = text[offSet...]
                    text = String(sub)
                }
                let sentences = text.split(separator: ".").suffix(2)
                text = ""
                for sentence in sentences{
                    text += String(sentence)
                }
                self.suggestionTagsObserver.text = text
        }
    }
}

struct DreamDetailContentView : View {
    @EnvironmentObject var dream : DreamViewModel
    
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var editorObserver : EditorObserver
    
    var body: some View{
        GeometryReader{ geo in
            ZStack(alignment: .bottom){
                Color.background1.edgesIgnoringSafeArea(.all)
                VStack(spacing: .small){
                    DreamDetailTopBar()
                    DreamDetailMainContentView()
                        .padding(.horizontal, .medium)
                }.navigationBarTitle("",displayMode: .inline)
                    .navigationBarHidden(true)
                
                DreamDetailKeyboardBar()
                
                BlurView()
                    .opacity(self.editorObserver.isInTagMode || self.editorObserver.currentMode == Modes.actionMode ? 1 : 0)
                    .disabled(!(self.editorObserver.isInTagMode || self.editorObserver.currentMode == Modes.actionMode))
                    .animation(.easeInOut)
            
                TagEditView(geo: geo)
                    .frame(height : geo.size.height, alignment: .top)
                    .opacity(self.editorObserver.isInTagMode ? 1 : 0)
                    .offset(x : 0, y : self.editorObserver.isInTagMode ? 0 : -30)
                    .disabled(!self.editorObserver.isInTagMode)
                
                ActionAlert(geo : geo)
                    .frame(height : geo.size.height, alignment: .bottom)
                    .animation(nil)
                    .opacity(self.editorObserver.currentMode == .actionMode ? 1 : 0)
                    .offset(x:0, y:self.editorObserver.currentMode == .actionMode ? 0 : 200)
                    .disabled(self.editorObserver.currentMode != .actionMode)
                    .animation(.easeInOut)
            }
        }
    }
}


struct BlurView : View {
    var body: some View{
        ZStack{
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
        }
    }
}


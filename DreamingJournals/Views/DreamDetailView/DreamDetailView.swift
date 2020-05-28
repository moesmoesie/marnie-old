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
    @ObservedObject var suggestionTagsObserver : SuggestionTagsObserver
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    
    init(dream : Dream) {
        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.managedObjectContext
        let tagService = TagService(managedObjectContext: context)
        self.suggestionTagsObserver = SuggestionTagsObserver(allTags: tagService.getUniqueTags())
        self.oldDream = OldDream(DreamViewModel(dream: dream))
        self.dream = DreamViewModel(dream: dream)
    }
    
    init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.managedObjectContext
        let tagService = TagService(managedObjectContext: context)
        self.suggestionTagsObserver = SuggestionTagsObserver(allTags: tagService.getUniqueTags())
        self.oldDream = OldDream(DreamViewModel())
        self.dream = DreamViewModel()
    }
    
    
    
    var body: some View {
        DreamDetailContentView()
            .environmentObject(dream)
            .environmentObject(editorObserver)
            .environmentObject(oldDream)
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


struct BlurView : View {
    var body: some View{
        ZStack{
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
        }
    }
}

class OldDream : ObservableObject{
    let dream : DreamViewModel
    
    init(_ oldDream : DreamViewModel) {
        self.dream = oldDream
    }
}


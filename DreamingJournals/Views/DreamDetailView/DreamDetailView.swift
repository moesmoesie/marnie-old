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
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var editorObserver : EditorObserver
    
    var body: some View{
        GeometryReader{ geo in
            ZStack(alignment: .bottom){
                self.theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
                VStack(spacing: self.theme.smallPadding){
                    DreamDetailTopBar()
                    DreamDetailMainContentView()
                        .padding(.horizontal, self.theme.mediumPadding)
                }.navigationBarTitle("",displayMode: .inline)
                    .navigationBarHidden(true)
                
                DreamDetailKeyboardBar()
                
                BlurView()
                    .opacity(self.editorObserver.isInTagMode || self.editorObserver.currentMode == Modes.actionMode ? 1 : 0)
                    .disabled(!(self.editorObserver.isInTagMode || self.editorObserver.currentMode == Modes.actionMode))
                    .animation(.easeInOut)
            
                TagEditView(maxHeight: geo.size.height)
                    .frame(height : geo.size.height, alignment: .top)
                    .animation(nil)
                    .opacity(self.editorObserver.isInTagMode ? 1 : 0)
                    .offset(x:0, y:self.editorObserver.isInTagMode ? 0 : 30)
                    .disabled(!self.editorObserver.isInTagMode)
                    .animation(.easeInOut)
                
                ActionAlert(geo : geo)
                    .frame(height : geo.size.height, alignment: .top)
                    .animation(nil)
                    .opacity(self.editorObserver.currentMode == .actionMode ? 1 : 0)
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


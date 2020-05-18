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
    @ObservedObject var suggestionTagsObserver = SuggestionTagsObserver()

    init(dream : DreamViewModel) {
        self.dream = dream.getCopy()
    }
    
    var body: some View {
        DreamDetailContentView()
            .environmentObject(dream)
            .environmentObject(editorObserver)
        .   environmentObject(suggestionTagsObserver)
            .onReceive(editorObserver.$cursorPosition) {(position : Int) in
                var text = String(self.dream.text.prefix(position))
                if position > 100{
                    let offSet = text.index(text.endIndex, offsetBy: -100)
                    let sub = text[offSet...]
                    text = String(sub)
                }
                if let newText = text.split(separator: ".").last{
                    text = String(newText)
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
        ZStack(alignment: .bottom){
            theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: theme.smallPadding){
                DreamDetailTopBar()
                DreamDetailMainContentView()
                    .padding(.horizontal, theme.mediumPadding)
            }.navigationBarTitle("",displayMode: .inline)
            .navigationBarHidden(true)
                
            
            TagEditView()
           
            DreamDetailKeyboardBar()
        }
    }
}


//
//  DreamDetailKeyboardBar.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailKeyboardBar: View {
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var editorObserver : EditorObserver
    
    @EnvironmentObject var theme : Theme
    var body: some View {
        return HStack(alignment: .bottom){
            SuggestionTags()
                .padding(.bottom , self.theme.extraSmallPadding)
            
            Spacer()
            
            DimissKeyboardButton()
                .padding(.bottom, theme.extraSmallPadding + 2)
                .padding(.trailing, theme.mediumPadding)
            
        }
        .padding(.bottom, keyboardObserver.height)
        .opacity(keyboardObserver.isKeyboardShowing && !editorObserver.isInTagMode ? 1 : 0)
        .disabled(!keyboardObserver.isKeyboardShowing)
        .animation(.easeIn)
    }
}

struct SuggestionTags : View {
    @EnvironmentObject var suggestionTagsObserver : SuggestionTagsObserver
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    
    var body : some View{
        let tagsToShow = self.suggestionTagsObserver.tags.filter({!self.dream.tags.contains($0)}).suffix(3)
        return
            ForEach(tagsToShow) { (tag : TagViewModel) in
                TagView(tag: tag)
                    .transition(.opacity)
                    .onTapGesture {
                        self.dream.tags.append(tag)
                }.padding(.leading , self.theme.mediumPadding)
        }
    }
}


private struct DimissKeyboardButton : View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    var body: some View{
        BetterButton(scale: 2, action: {
            mediumFeedback()
            self.keyboardObserver.dismissKeyboard()
        }){
            Image(systemName: "chevron.down.square.fill")
                .font(.system(size: 20, weight: .regular, design: .default))
                .foregroundColor(self.theme.secondaryAccentColor)
                .background(self.theme.primaryBackgroundColor)
        }
    }
}


private struct MenuView : View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        SuggestionTags()
    }
}

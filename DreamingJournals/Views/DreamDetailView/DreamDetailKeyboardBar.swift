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
        return GeometryReader{ geo in
            ZStack(alignment:.bottom){
                VStack{
                    Spacer()
                    HStack{
                        SuggestionTags()
                       

                        Spacer()
                        DimissKeyboardButton()
                    }
                }
            }
            .frame(width: geo.size.width)
        }.padding(.bottom, keyboardObserver.height)
        .opacity(keyboardObserver.isKeyboardShowing && !editorObserver.isInTagMode ? 1 : 0)
        .disabled(!keyboardObserver.isKeyboardShowing)
    }
}






struct SuggestionTags : View {
    @EnvironmentObject var suggestionTagsObserver : SuggestionTagsObserver
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    
    var tagsToSuggest : [TagViewModel]{
        var tags : [TagViewModel] = []
        for tag in suggestionTagsObserver.tags{
            if !self.dream.tags.contains(tag){
                tags.append(tag)
            }
        }
        return tags
    }


    var body : some View{
        return ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(self.tagsToSuggest) { (tag : TagViewModel) in
                    TagView(tag: tag)
                        .padding(.trailing, self.theme.smallPadding)
                        .padding(.bottom, self.theme.extraSmallPadding)
                        .onTapGesture {
                            self.dream.tags.append(tag)
                    }
                }
            }.padding(.leading, self.theme.mediumPadding)
            .frame(height: 30)
        }
    }
}


private struct DimissKeyboardButton : View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    var body: some View{
        Button(action:{
            self.keyboardObserver.dismissKeyboard()
        }){
            Image(systemName: "keyboard.chevron.compact.down").foregroundColor(.white)
                .padding(.vertical, theme.smallPadding * 1.2 )
                .padding(.horizontal, theme.mediumPadding)
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

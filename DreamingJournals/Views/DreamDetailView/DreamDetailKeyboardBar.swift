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

    var body: some View {
        return HStack(alignment: .center){
            Spacer()
            
            ActivateTagFilterSheetButton()
                .padding(.trailing, .medium)
                .padding(.bottom, .small)
            
            DismissKeyboardButton()
                .padding(.trailing, .medium)
                .padding(.bottom, .small)
            
        }
        .padding(.bottom,keyboardObserver.isKeyboardShowing ?  keyboardObserver.heightWithoutSaveArea : 100)
        .opacity(keyboardObserver.isKeyboardShowing ? 1 : 0)
        .disabled(!keyboardObserver.isKeyboardShowing)
        .animation(.easeOut(duration: 0.4))
    }
}

private struct ActivateTagFilterSheetButton : View{
    @EnvironmentObject var editorObserver : EditorObserver

    var body: some View{
        CustomPassiveIconButton(iconName: "tag", iconSize: .small) {
            self.editorObserver.currentMode = Modes.tagMode
        }
    }
}

private struct DismissKeyboardButton : View{
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    
    var body: some View{
        CustomPassiveIconButton(iconName: "chevron.down.square", iconSize: .small) {
            self.keyboardObserver.dismissKeyboard()
        }
    }
}

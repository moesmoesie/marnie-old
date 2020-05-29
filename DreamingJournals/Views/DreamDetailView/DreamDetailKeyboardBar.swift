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
            
            CustomIconButton(iconName: "tag", iconSize: .small, isActive: false) {
                self.editorObserver.currentMode = Modes.tagMode
            }.padding(.trailing, .medium)
            .padding(.bottom, .small)
            
            CustomIconButton(iconName: "chevron.down.square", iconSize: .small, isActive: false) {
                self.keyboardObserver.dismissKeyboard()
            }.padding(.trailing, .medium)
            .padding(.bottom, .small)
            
        }
        .padding(.bottom,keyboardObserver.isKeyboardShowing ?  keyboardObserver.heightWithoutSaveArea : 100)
        .opacity(keyboardObserver.isKeyboardShowing ? 1 : 0)
        .disabled(!keyboardObserver.isKeyboardShowing)
        .animation(.easeOut(duration: 0.4))
    }
}

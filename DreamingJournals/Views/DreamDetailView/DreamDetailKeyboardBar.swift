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
        return MenuView()
                .animation(nil)
                .padding(.bottom, keyboardObserver.height)
            .opacity(keyboardObserver.isKeyboardShowing && !editorObserver.isInTagMode ? 1 : 0)
                .animation(.easeInOut(duration: keyboardObserver.animationTime + 0.2))
                .disabled(!keyboardObserver.isKeyboardShowing)
    }
}

private struct MenuView : View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        HStack(alignment: .center){
            Spacer()
            DimissKeyboardButton()
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

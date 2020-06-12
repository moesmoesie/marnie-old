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
        let showMainKeyboard = keyboardObserver.isKeyboardShowing && !editorObserver.isInTagMode
        let showTagKeyboard = keyboardObserver.isKeyboardShowing && editorObserver.isInTagMode
        
        return
            ZStack{
                HStack(spacing : .medium){
                    Spacer()
                    ActivateTagFilterSheetButton()
                    DismissKeyboardButton()
                }
                .padding(.bottom, .small)
                .opacity(showMainKeyboard ? 1 : 0)
                .offset(y : showMainKeyboard ? 0 : 300)
                .disabled(!showMainKeyboard)
                
                HStack(spacing : .medium){
                    Spacer()
                    DismissTagSheetButton()
                }.padding(.bottom, .small)
                .opacity(showTagKeyboard ? 1 : 0)
                .offset(y : showTagKeyboard ? 0 : 300)
                .disabled(!showTagKeyboard)
            }
            .animation(Animation.spring().speed(1.3))
            .padding(.bottom, keyboardObserver.heightWithoutSaveArea)
            .padding(.horizontal, .medium)
    }
}

private struct ActivateTagFilterSheetButton : View{
    @EnvironmentObject var editorObserver : EditorObserver

    var body: some View{
        CustomPassiveIconButton(icon: .tagIcon, iconSize: .small) {
            withAnimation(.timingCurve(0.4, 0.8, 0.2, 1, duration : 0.7)){
                self.editorObserver.currentMode = Modes.tagMode
            }
        }
    }
}

private struct DismissKeyboardButton : View{
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    
    var body: some View{
        CustomPassiveIconButton(icon: .dismissKeyboardIcon, iconSize: .small) {
            self.keyboardObserver.dismissKeyboard()
        }
    }
}

private struct DismissTagSheetButton : View{
    @EnvironmentObject var editorObserver : EditorObserver
    @EnvironmentObject var keyboardObserver : KeyboardObserver

    var body: some View{
        Button(action: {
            withAnimation(.spring()){
                self.keyboardObserver.dismissKeyboard()
                self.editorObserver.currentMode = Modes.regularMode
            }
        }){
            Text("Done")
                .font(.primarySmall)
                .fontWeight(.heavy)
                .padding(.horizontal,.small * 1.2)
                .padding(.vertical,.extraSmall)
                .background(Color.main1)
                .foregroundColor(.background1)
                .cornerRadius(12.5)
        }
    }
}

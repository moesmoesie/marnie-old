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
        return
            ZStack{
                if editorObserver.currentMode == Modes.tagMode{
                    HStack(alignment: .center){
                        Spacer()
                        DismissTagSheetButton()
                            .padding(.trailing, .medium)
                            .padding(.bottom, .small)
                    }
                }
                if editorObserver.currentMode == .regularMode{
                    HStack(alignment: .center){
                        Spacer()
                        ActivateTagFilterSheetButton()
                            .padding(.trailing, .medium)
                            .padding(.bottom, .small)
                        
                        DismissKeyboardButton()
                            .padding(.trailing, .medium)
                            .padding(.bottom, .small)
                    }
                }
            }.padding(.bottom,keyboardObserver.isKeyboardShowing ?  keyboardObserver.heightWithoutSaveArea : 100)
            .opacity(keyboardObserver.isKeyboardShowing ? 1 : 0)
            .disabled(!keyboardObserver.isKeyboardShowing)
            .animation(.spring())
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

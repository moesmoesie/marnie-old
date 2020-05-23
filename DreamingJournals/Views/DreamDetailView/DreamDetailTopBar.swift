//
//  DreamDetailTopBar.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailTopBar: View {
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var editorObserver : EditorObserver
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert : Bool = false
    @State var currentAlert : Alert = Alert(title: Text("Error"))
    
    
    var body: some View {
        HStack(alignment : .center,spacing : .medium){
            backView
            Spacer()
            tagView
            bookmarkedView
            actionButton
                .padding(.trailing, .medium)
        }
    }
    
    //MARK: - Helper Views
    
    var actionButton : some View{
        Button(action: {
            mediumFeedback()
            self.editorObserver.currentMode = .actionMode
        }){
            Image(systemName: "ellipsis").foregroundColor(.accent2)
                .padding(.vertical, .small)
        }
    }
    
    var tagView : some View{
        Button(action: {
            mediumFeedback()
            withAnimation{
                if self.editorObserver.isInTagMode{
                    self.editorObserver.currentMode = .regularMode
                }else{
                    self.editorObserver.currentMode = .tagMode
                }
            }
            
        }){
            Image(systemName: "tag.fill").foregroundColor(.accent2)
                .padding(.vertical, .small)
        }
    }
    
    var bookmarkedView : some View{
        Button(action:{
            mediumFeedback()
            self.dream.isBookmarked.toggle()
        }){
            Image(systemName: "heart.fill")
                .foregroundColor(self.dream.isBookmarked ? .accent1 : .secondary)
                .padding(.vertical, .small)
        }
    }
    
    var backView : some View{
        Button(action:backButtonPress){
            Image(systemName: "chevron.left").foregroundColor(.accent2)
                .padding(.vertical, .small)
                .padding(.horizontal, .medium)
        }.alert(isPresented: $showAlert) {
            self.currentAlert
        }
    }

    //MARK: - ALERTS
    func unsavedChangesAlert() -> Alert {
        Alert(title: Text("Unsaved Changes"), message: Text("You have made changes without saving!"), primaryButton: .destructive(Text("Discard"), action:{
            self.presentationMode.wrappedValue.dismiss()
        }), secondaryButton: .cancel())
    }
    
    //MARK: - Logic Funtions

    func backButtonPress(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        keyboardObserver.dismissKeyboard()
        if dreamService.checkForChanges(dream){
            self.currentAlert = unsavedChangesAlert()
            self.showAlert = true
        }else{
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

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
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var editorObserver : EditorObserver
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert : Bool = false
    @State var currentAlert : Alert = Alert(title: Text("Error"))
    
    
    var body: some View {
        HStack(alignment : .center,spacing : self.theme.mediumPadding){
            backView
            Spacer()
            tagView.padding(.bottom, -theme.extraSmallPadding)
            if dream.isNewDream{
                saveView
            }else{
                updateView
            }
            
            if !dream.isNewDream{
                deleteView
            }
            bookmarkedView
        }
    }
    
    //MARK: - Helper Views
    
    var tagView : some View{
        Button(action: {
            if self.editorObserver.isInTagMode{
                self.editorObserver.currentMode = .regularMode
            }else{
                self.editorObserver.currentMode = .tagMode
            }
            
        }){
            Image(systemName: "tag.fill").foregroundColor(editorObserver.isInTagMode ? theme.selectedAccentColor : theme.unSelectedAccentColor)
                .padding(.vertical, theme.smallPadding)
        }
    }
    
    var saveView : some View{
        Button(action: saveDream){
            Image(systemName: "tray.and.arrow.down.fill").foregroundColor(theme.positiveActionColor)
                .padding(.vertical, theme.smallPadding)
        }.alert(isPresented: $showAlert){
            self.currentAlert
        }
    }
    
    var bookmarkedView : some View{
        Button(action:{
            self.dream.isBookmarked.toggle()
        }){
            Image(systemName: "heart.fill")
                .foregroundColor(self.dream.isBookmarked ? theme.selectedAccentColor : theme.unSelectedAccentColor)
                .padding(.vertical, theme.smallPadding)
                .padding(.trailing, theme.mediumPadding)
        }
    }
    
    var deleteView : some View{
        Button(action:deleteDream){
            Image(systemName: "trash.fill")
                .foregroundColor(theme.negativeActionColor)
                .padding(.vertical, theme.smallPadding)
        }
    }
    
    var backView : some View{
        Button(action:backButtonPress){
            Image(systemName: "chevron.left").foregroundColor(theme.secondaryAccentColor)
                .padding(.vertical, theme.smallPadding)
                .padding(.horizontal, theme.mediumPadding)
        }.alert(isPresented: $showAlert) {
            self.currentAlert
        }
    }
    
    var updateView : some View{
        Button(action: updateDream){
            Image(systemName: "tray.and.arrow.down.fill").foregroundColor(theme.positiveActionColor)
                .padding(.vertical, theme.smallPadding)
        }.alert(isPresented: $showAlert){
            self.currentAlert
        }
    }
    //MARK: - ALERTS
    func unsavedChangesAlert() -> Alert {
        Alert(title: Text("Unsaved Changes"), message: Text("You have made changes without saving!"), primaryButton: .destructive(Text("Discard"), action:{
            self.presentationMode.wrappedValue.dismiss()
        }), secondaryButton: .cancel())
    }
    
    func invalidUpdateAlert(message : String) -> Alert{
        Alert(title: Text("Invalid Update"), message: Text(message), dismissButton: .default(Text("OK")))
    }
    
    func updatingNonExistingDreamAlert() -> Alert{
        let message = "The dream you are tryin to update doesn't exist anymore. You can save it instead."
        
        return Alert(title: Text("Invalid Update"), message: Text(message), primaryButton: .destructive(Text("DELETE"), action: {
            self.moc.reset()
            self.presentationMode.wrappedValue.dismiss()
        }), secondaryButton: .default(Text("Save")) {
            self.saveDream()
            })
    }
    
    func invalidSaveAlert(message : String ) -> Alert{
        Alert(title: Text("Invalid Save"), message: Text(message), dismissButton: .default(Text("OK")))
    }
    
    //MARK: - Logic Funtions
    
    func backButtonPress(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        if dreamService.checkForChanges(dream){
            self.currentAlert = unsavedChangesAlert()
            self.showAlert = true
        }else{
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func updateDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        self.showAlert = false
        
        do {
            try dreamService.updateDream(dreamViewModel: dream)
            presentationMode.wrappedValue.dismiss()
        } catch DreamService.DreamError.invalidUpdate(let message){
            self.currentAlert = invalidUpdateAlert(message: message)
            showAlert = true
        } catch DreamService.DreamError.updatingNonExistingDream{
            self.currentAlert =  updatingNonExistingDreamAlert()
            self.showAlert = true
        } catch{
            print("Unexpected error: \(error).")
        }
    }
    
    
    func deleteDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        
        do{
            try dreamService.deleteDream(dream)
            presentationMode.wrappedValue.dismiss()
        }catch DreamService.DreamError.invalidDelete(error: let message){
            print(message)
        }catch{
            print("Unexpected error: \(error).")
        }
    }
    
    
    func saveDream(){
        self.showAlert = false
        let dreamService = DreamService(managedObjectContext: self.moc)
        do {
            try dreamService.saveDream(dreamViewModel: dream)
            presentationMode.wrappedValue.dismiss()
        } catch DreamService.DreamError.invalidSave(error: let message) {
            self.currentAlert = invalidSaveAlert(message: message)
            self.showAlert = true
        } catch{
            print("Unexpected error: \(error).")
        }
    }
}

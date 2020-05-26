//
//  DreamDetailTopBar.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailTopBar: View {
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var oldDream : OldDream
    @State var showSaveButton = false
    var body: some View {
        onViewUpdate()
        return ZStack{
            DreamDateView()
            HStack(alignment : .center,spacing : .medium){
                BackButton()
                Spacer()
                if showSaveButton{
                    SaveButton()
                        .transition(.offset(x: .extraLarge * 2))
                        .animation(.easeInOut)
                }
            }
        }
    }
    
    func onViewUpdate(){
        let isDreamChanged = dream.isEqualTo(oldDream.dream)
        if showSaveButton == isDreamChanged{
            DispatchQueue.main.async {
                self.showSaveButton.toggle()
            }
        }
    }
}

private struct DreamDateView : View{
    
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        Text(dream.wrapperDateString)
            .font(.primarySmall)
            .foregroundColor(.main2)
    }
}

private struct SaveButton : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert = false
    @State var message = ""
    
    var body: some View{
        Button(action: dream.isNewDream ? saveDream : updateDream){
            Text(dream.isNewDream ?  "Save" : "Update")
                .foregroundColor(.main1)
                .font(.secondaryLarge)
                .padding(.trailing, .medium)
        }.buttonStyle(PlainButtonStyle())
            .alert(isPresented: $showAlert, content: InvalidSaveAlert)
    }
    
    
    
    func saveDream(){
        mediumFeedback()
        self.showAlert = false
        let dreamService = DreamService(managedObjectContext: self.moc)
        do {
            try dreamService.saveDream(dreamViewModel: dream)
            presentationMode.wrappedValue.dismiss()
        } catch DreamService.DreamError.invalidSave(error: let message) {
            self.message = message
            self.showAlert = true
        } catch{
            print("Unexpected error: \(error).")
        }
    }
    
    func InvalidSaveAlert() -> Alert{
        Alert(title: Text(self.dream.isNewDream ? "Invalid Save" : "Invalid Update"), message: Text(self.message), dismissButton: .default(Text("OK")))
    }
    
    func updateDream(){
        mediumFeedback()
        let dreamService = DreamService(managedObjectContext: self.moc)
        self.showAlert = false
        
        do {
            try dreamService.updateDream(dreamViewModel: dream)
            presentationMode.wrappedValue.dismiss()
        } catch DreamService.DreamError.invalidUpdate(let message){
            self.message = message
            self.showAlert = true
        } catch DreamService.DreamError.updatingNonExistingDream{
            self.saveDream()
        } catch{
            print("Unexpected error: \(error).")
        }
    }
}


private struct BackButton : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert = false
    
    var body: some View{
        Button(action:backButtonPress){
            Image(systemName: "chevron.left").foregroundColor(.main1)
                .padding(.vertical, .extraSmall)
                .padding(.horizontal, .medium)
        }.alert(isPresented: $showAlert, content: unsavedChangesAlert)
    }
    
    func backButtonPress(){
        mediumFeedback()
        let dreamService = DreamService(managedObjectContext: self.moc)
        keyboardObserver.dismissKeyboard()
        if dreamService.checkForChanges(dream){
            self.showAlert = true
        }else{
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func unsavedChangesAlert() -> Alert {
        Alert(title: Text("Unsaved Changes"), message: Text("You have made changes without saving!"), primaryButton: .destructive(Text("Discard"), action:{
            self.presentationMode.wrappedValue.dismiss()
        }), secondaryButton: .cancel())
    }
}

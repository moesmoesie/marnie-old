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
        return
            HStack(spacing : 0){
                BackButton()
                Spacer()
                ShareButton()
                    .offset(y : -2.5)
                    .padding(.horizontal,.medium)

                if showSaveButton{
                    SaveButton(text: dream.isNewDream ?  "Save" : "Update")
                        .padding(.trailing, .medium)
                         .transition(.offset(x: .extraLarge * 2))
                }
            }
            .frame(height: .extraLarge)
            .padding(.top,getTopSaveArea())
            .background(Color.background1.opacity(0.99))
    }
    
    func onViewUpdate(){
        let isDreamChanged = dream.isEqualTo(oldDream.dream)
        if showSaveButton == isDreamChanged{
            DispatchQueue.main.async {
                withAnimation{
                    self.showSaveButton.toggle()
                }
            }
        }
    }
}

private struct SaveButton : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert = false
    @State var message = ""
    let text : String
    
    var body: some View{
        Button(action: dream.isNewDream ? saveDream : updateDream){
            Text(text)
                .foregroundColor(.main1)
                .font(.primaryRegular)
        }.buttonStyle(PlainButtonStyle())
        .alert(isPresented: $showAlert, content: InvalidSaveAlert)
    }
    
    func InvalidSaveAlert() -> Alert{
        Alert(title: Text(self.dream.isNewDream ? "Invalid Save" : "Invalid Update"), message: Text(self.message), dismissButton: .default(Text("OK")))
    }
    
    func saveDream(){
        mediumFeedback()
        self.showAlert = false
        do {
            try Dream.saveDream(dream, context: managedObjectContext)
            presentationMode.wrappedValue.dismiss()
        } catch Dream.DreamError.invalidSave(error: let message) {
            self.message = message
            self.showAlert = true
        } catch{
            print("Unexpected error: \(error).")
        }
    }
    
    func updateDream(){
        mediumFeedback()
        self.showAlert = false
        
        do {
            try Dream.updateDream(dream, context: managedObjectContext)
            presentationMode.wrappedValue.dismiss()
        } catch Dream.DreamError.invalidUpdate(let message){
            self.message = message
            self.showAlert = true
        } catch Dream.DreamError.updatingNonExistingDream{
            self.saveDream()
        } catch{
            print("Unexpected error: \(error).")
        }
    }
}


private struct BackButton : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var oldDream : OldDream
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert = false
    
    var body: some View{
        Button(action:backButtonPress){
            Image.backIcon.foregroundColor(.main1)
                .padding(.medium)
        }.alert(isPresented: $showAlert, content: unsavedChangesAlert)
    }
    
    func backButtonPress(){
        mediumFeedback()
        keyboardObserver.dismissKeyboard()
        
        if !oldDream.dream.isEqualTo(dream){
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

private struct ShareButton : View{
    @EnvironmentObject var dream : DreamViewModel
    @State var showAlert = false
    
    var body: some View{
        Button(action:onButtonPress){
            Image(systemName: "square.and.arrow.up").foregroundColor(.main1)
        }.sheet(isPresented: $showAlert) {
            ShareView(activityItems:  [PDFCreator.createDreamPDF(dream: self.dream)])
                .colorScheme(.dark)
                .background(Color.background1.edgesIgnoringSafeArea(.all))
        }
    }
    
    func onButtonPress(){
        self.showAlert = true
    }
}

//
//  DreamDetailTopBar.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailTopBar: View {
    var body: some View {
        HStack(alignment : .center,spacing : .medium){
            BackButton()
            Spacer()
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
            Image(systemName: "chevron.left").foregroundColor(.accent2)
                .padding(.vertical, .small)
                .padding(.horizontal, .medium)
        }.alert(isPresented: $showAlert, content: unsavedChangesAlert)
    }
    
    func backButtonPress(){
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

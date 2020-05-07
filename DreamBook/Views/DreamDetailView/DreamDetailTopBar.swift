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
    
    var body: some View {
        HStack(alignment : .bottom,spacing : self.theme.mediumPadding){
            DreamBackView()
            Spacer()
            if dream.isNewDream{
                DreamSaveView()
            }else{
                DreamUpdateView()
            }
            
            if !dream.isNewDream{
                DreamDeleteView()
            }
            DreamBookmarkedView()
        }.padding(.vertical, theme.smallPadding)
    }
}


private struct DreamDeleteView : View{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    
    var body : some View{
        Button(action:deleteDream){
            Image(systemName: "trash.fill")
                .foregroundColor(theme.tertiaryColor)
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
}

private struct DreamBackView : View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var theme : Theme
    
    var body : some View{
        Button(action:backButtonPress){
            Image(systemName: "chevron.left").foregroundColor(theme.passiveLightColor)
        }
    }
    
    func backButtonPress(){
        self.presentationMode.wrappedValue.dismiss()
    }
}

private struct DreamSaveView : View{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel

    @State var currentAlert : Alert = Alert(title: Text("Error"))
    @State var showAlert = false
    
    var body : some View{
        Button(action: saveDream){
            Image(systemName: "tray.and.arrow.down.fill").foregroundColor(theme.secundaryColor)
        }.alert(isPresented: $showAlert){
            self.currentAlert
        }
    }
    
    func saveDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        do {
            try dreamService.saveDream(dreamViewModel: dream)
            presentationMode.wrappedValue.dismiss()
        } catch DreamService.DreamError.invalidSave(error: let message) {
            self.currentAlert = Alert(title: Text("Invalid Save"), message: Text(message), dismissButton: .default(Text("OK")))
            self.showAlert = true
        } catch{
            print("Unexpected error: \(error).")
        }
    }
}

private struct DreamUpdateView : View{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    @State var currentAlert : Alert = Alert(title: Text("Error"))
    @State var showAlert = false
    
    var body : some View{
        Button(action: updateDream){
            Image(systemName: "tray.and.arrow.down.fill").foregroundColor(theme.secundaryColor)
        }.alert(isPresented: $showAlert, content: {self.currentAlert})
    }
    
    func updateDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        do {
            try dreamService.updateDream(dreamViewModel: dream)
            presentationMode.wrappedValue.dismiss()
        } catch DreamService.DreamError.invalidUpdate(let message){
            self.currentAlert = Alert(title: Text("Invalid Update"), message: Text(message), dismissButton: .default(Text("OK")))
            showAlert = true
        } catch DreamService.DreamError.updatingNonExistingDream{
            let errorMessage = "The dream you are tryin to update doesn't exist anymore. You can save it instead."
            self.currentAlert =  Alert(title: Text("Invalid Update"), message: Text(errorMessage), primaryButton: .destructive(Text("DELETE"), action: {
                self.moc.reset()
                self.presentationMode.wrappedValue.dismiss()
            }), secondaryButton: .default(Text("Save")) {
                self.saveDream()
                })
            self.showAlert = true
        } catch{
            print("Unexpected error: \(error).")
        }
    }
    
    func saveDream(){
          let dreamService = DreamService(managedObjectContext: self.moc)
          do {
              try dreamService.saveDream(dreamViewModel: dream)
              presentationMode.wrappedValue.dismiss()
          } catch DreamService.DreamError.invalidSave(error: let message) {
              self.currentAlert = Alert(title: Text("InvalidSave"), message: Text(message), dismissButton: .default(Text("OK")))
              self.showAlert = true
          } catch{
              print("Unexpected error: \(error).")
          }
      }
}

private struct DreamBookmarkedView : View{
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    var body : some View{
        Button(action:{
            self.dream.isBookmarked.toggle()
        }){
            Image(systemName: "heart.fill")
                .foregroundColor(self.dream.isBookmarked ? theme.primaryColor : theme.passiveDarkColor)
        }
    }
}

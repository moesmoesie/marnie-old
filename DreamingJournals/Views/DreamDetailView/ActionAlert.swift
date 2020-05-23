//
//  ActionAlert.swift
//  DreamingJournals
//
//  Created by moesmoesie on 20/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct ActionAlert: View {
    @EnvironmentObject var editorObserver : EditorObserver
    
    @EnvironmentObject var dream : DreamViewModel
    
    @State var showAlert : Bool = false
    @State var currentAlert : Alert = Alert(title: Text(""))
    @State var message : String = ""
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    let geo : GeometryProxy
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Spacer()
                closeButtonView
                    .padding([.top,.trailing], .medium)
            }
            Spacer()
            saveButton
            deleteButton
            Spacer()
            Spacer()
            Text(message)
            Spacer()
        }
        .frame(width: geo.size.width, height: geo.size.height / 3)
        .background(Color.background2)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var closeButtonView : some View{
        Button(action: {
            self.editorObserver.currentMode = .regularMode
            mediumFeedback()
        }){
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width : .large, height: .large)
                .foregroundColor(.accent2)
            
        }
    }
    
    private var deleteButton : some View{
        Button(action:{
            self.deleteDream()
        }){
            HStack(alignment: .center){
                Spacer()
                Image(systemName: "trash.fill").font(.headline).foregroundColor(.primary)
                Text("Delete")
                    .font(Font.primaryLarge)
                    .foregroundColor(.primary)
                Spacer()
            }
            
        }
        .padding(.vertical, .small)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, .medium)
    }
    
    private var saveButton : some View{
        Button(action:{
            if self.dream.isNewDream{
                self.saveDream()
            }else{
                self.updateDream()
            }
        }){
            HStack(alignment: .center){
                Spacer()
                Image(systemName: "tray.and.arrow.down.fill").font(.headline).foregroundColor(.primary)
                Text(self.dream.isNewDream ? "Save" : "Update").font(Font.primaryLarge).foregroundColor(.primary)
                Spacer()
            }
        }
        .padding(.vertical, .small)
        .background(Color.background1)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.bottom, .medium)
        .padding(.horizontal, .medium)

        
    }
    
    //MARK: - Logic Funtions
    
    func updateDream(){
        mediumFeedback()
        let dreamService = DreamService(managedObjectContext: self.moc)
        self.showAlert = false
        
        do {
            try dreamService.updateDream(dreamViewModel: dream)
            presentationMode.wrappedValue.dismiss()
        } catch DreamService.DreamError.invalidUpdate(let message){
            self.message = message
        } catch DreamService.DreamError.updatingNonExistingDream{
            self.message = "Updating a dream that doesnt exit!"
        } catch{
            print("Unexpected error: \(error).")
        }
    }
    
    func deleteDream(){
        heavyFeedback()
        let dreamService = DreamService(managedObjectContext: self.moc)
        do{
            try dreamService.deleteDream(dream)
            presentationMode.wrappedValue.dismiss()
        }catch DreamService.DreamError.invalidDelete(error: let message){
            self.message = message
        }catch{
            print("Unexpected error: \(error).")
        }
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
}

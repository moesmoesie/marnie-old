//
//  DreamDetailView.swift
//  dream-book
//
//  Created by moesmoesie on 24/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var title : String
    @State var text : String

    var dream : Dream?
    var isNewDream : Bool{
        dream == nil
    }
    
    init(dream : Dream) {
        self.dream = dream
        _title = .init(initialValue: dream.title ?? "")
        _text = .init(initialValue: dream.text ?? "")
    }
    
    init() {
        _title = .init(initialValue: "")
        _text = .init(initialValue: "")
    }
    
    var body: some View {
        VStack {
            Form{
                TextField("Title", text: $title)
                TextField("Text", text: $text)
                if !isNewDream{
                    Button("Delete", action: deleteDream)
                }

                Button(isNewDream ? "Save" : "Update",
                       action: isNewDream ? saveDream : updateDream)
            }
        }
    }
    
    func updateDream(){
        if let updatedDream = dream{
            do {
                try updatedDream.updateDream(moc: moc, title: title, text: text)
                presentationMode.wrappedValue.dismiss()
            } catch Dream.DreamError.invalidUpdate(let message){
                print(message)
            } catch Dream.DreamError.updatingNonExistingDream{
                print("Cant update a dream that doesn't exist!")
            } catch{
                print("Unexpected error: \(error).")
            }
        }else{
            print("Cant update a dream that doesnt exit!")
        }
    }
    
    func saveDream(){
        do {
            try Dream.saveDream(moc: moc, title: title, text: text)
            presentationMode.wrappedValue.dismiss()
        } catch Dream.DreamError.invalidSave(error: let message) {
            print(message)
        } catch{
            print("Unexpected error: \(error).")
        }
    }
    
    func deleteDream(){
        if let dreamToDelete = dream{
            do{
                try dreamToDelete.deleteDream(context: moc)
                presentationMode.wrappedValue.dismiss()
            }catch Dream.DreamError.invalidDelete(error: let message){
                print(message)
            }catch{
                print("Unexpected error: \(error).")
            }
        }
    }
}

struct DreamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailView()
    }
}

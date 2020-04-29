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
    @State var isBookmarked : Bool

    var dream : Dream?
    
    var isNewDream : Bool{
        dream == nil
    }
    
    init(dream : Dream) {
        self.dream = dream
        _title = .init(initialValue: dream.title ?? "")
        _text = .init(initialValue: dream.text ?? "")
        _isBookmarked = .init(initialValue: dream.isBookmarked)
    }
    
    init() {
        _title = .init(initialValue: "")
        _text = .init(initialValue: "")
        _isBookmarked = .init(initialValue: false)
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
                Toggle(isOn: $isBookmarked){
                    Text("Bookmarked")
                }
            }
        }
    }
    
    func updateDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        if let dreamToUpDate = dream{
            do {
                try dreamService.updateDream(dreamToUpDate, title: title, text: text, isBookmarked: isBookmarked)
                presentationMode.wrappedValue.dismiss()
            } catch DreamService.DreamError.invalidUpdate(let message){
                print(message)
            } catch DreamService.DreamError.updatingNonExistingDream{
                print("Cant update a dream that doesn't exist!")
            } catch{
                print("Unexpected error: \(error).")
            }
        }else{
            print("Cant update a dream that doesnt exit!")
        }
    }
    
    func saveDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        do {
            try dreamService.saveDream(id : UUID(), title: title, text: text, isBookmarked: isBookmarked)
            presentationMode.wrappedValue.dismiss()
        } catch DreamService.DreamError.invalidSave(error: let message) {
            print(message)
        } catch{
            print("Unexpected error: \(error).")
        }
    }
    
    func deleteDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        if let dreamToDelete = dream{
            do{
                try dreamService.deleteDream(dreamToDelete)
                presentationMode.wrappedValue.dismiss()
            }catch DreamService.DreamError.invalidDelete(error: let message){
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

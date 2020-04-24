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

                Button(isNewDream ? "Save" : "Update"){
                    if self.isNewDream{
                        self.saveDream()
                    }else{
                        self.updateDream()
                    }
                }
            }
        }
    }
    
    func updateDream(){
        let updatedDream : Dream
        if let tempDream = self.dream{
            updatedDream = tempDream
        }else{
            print("dream doesnt exits!")
            return
        }
        
        updatedDream.title = title
        updatedDream.text = text
        
        if updatedDream.hasPersistentChangedValues{
            do{
                try updatedDream.validateForUpdate()
                try moc.save()
            }catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func saveDream(){
        let newDream = Dream(entity: Dream.entity(), insertInto: nil)
        newDream.id = UUID()
        newDream.title = title
        newDream.text = text
        
        do{
            try newDream.validateForInsert()
            moc.insert(newDream)
            try moc.save()
            presentationMode.wrappedValue.dismiss()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}

struct DreamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailView()
    }
}

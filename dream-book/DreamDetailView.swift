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
    @State var title : String = ""

    var dream : Dream?
    var isNewDream : Bool{
        dream == nil
    }
    init(dream : Dream) {
        self.dream = dream
        _title = .init(initialValue: dream.title ?? "")
    }
    
    init() {
        _title = .init(initialValue: "")
    }
    
    var body: some View {
        VStack {
            Form{
                TextField("Title", text: $title)
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

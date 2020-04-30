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
    @State var date : Date
    @State var tags : [Tag]
    
    var dream : Dream?
    
    var isNewDream : Bool{
        dream == nil
    }
    
    init(dream : Dream) {
        self.dream = dream
        _title = .init(initialValue: dream.wrappedTitle)
        _text = .init(initialValue: dream.wrappedText)
        _isBookmarked = .init(initialValue: dream.isBookmarked)
        _date = .init(initialValue: dream.wrapperDate)
        _tags = .init(initialValue: dream.wrappedTags)
    }
    
    init() {
        _title = .init(initialValue: "")
        _text = .init(initialValue: "")
        _isBookmarked = .init(initialValue: false)
        _date = .init(initialValue: Date())
        _tags = .init(initialValue: [])
    }
    
    var body: some View {
        Form{
            TextField("Title", text: $title)
            TextField("Text", text: $text)
            
            if !isNewDream{
                Button("Delete", action: deleteDream)
            }
            
            DatePicker("Date", selection: $date, displayedComponents: .date)
            
            Button(isNewDream ? "Save" : "Update",
                   action: isNewDream ? saveDream : updateDream)
            Toggle(isOn: $isBookmarked){
                Text("Bookmarked")
            }
            
            HStack{
                ForEach(tags, id: \.self){ (tag : Tag) in
                    Text(tag.wrapperText)
                }
            }
            
            Button("Add random Tags"){
                let randomTags = ["Jeremy", "Skeet", "Je Moeder"]
                self.addTag(text: randomTags.randomElement()!)
            }
        }
    }
    
    func addTag(text : String){
        let tagService = TagService(managedObjectContext: self.moc)
        if let tag = tagService.getTag(text: text){
            if tags.contains(tag){
                return
            }
            tags.append(tag)
        }else{
            do{
                let tag = try tagService.createTag(text: text)
                if tags.contains(tag){
                    return
                }
                tags.append(tag)
            }catch{
                print("Cant create that tag")
            }
        }
    }
    
    func updateDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        if let dreamToUpDate = dream{
            do {
                try dreamService.updateDream(dreamToUpDate, title: title, text: text, isBookmarked: isBookmarked, date: date,tags: tags)
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
            try dreamService.saveDream(id : UUID(), title: title, text: text, isBookmarked: isBookmarked, date: date,tags: tags)
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

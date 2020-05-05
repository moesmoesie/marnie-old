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
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment : .leading){
                HStack{
                    DreamBackView()
                    Spacer()
                    if isNewDream{
                        DreamSaveView(title: title, text: text, isBookmarked: isBookmarked, date: date, tags: tags)
                    }else{
                        DreamUpdateView(dream: dream, title: title, text: text, isBookmarked: isBookmarked, date: date, tags: tags)
                    }
                    if !isNewDream{
                        DreamDeleteView(dream: dream)
                    }
                    DreamBookmarkedView(isBookmarked: $isBookmarked)
                }
                DreamTitleView(title: $title)
                TagCollectionView(tags: $tags)
                DreamAddTagView(tags: $tags)
                DreamTextView(text: $text)
            }
        }.navigationBarTitle("",displayMode: .inline)
            .navigationBarHidden(true)
    }
}

struct DreamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailView()
    }
}

private struct DreamBookmarkedView : View{
    @Binding var isBookmarked: Bool
    var body : some View{
        Button(action:{
            self.isBookmarked.toggle()
        }){
            Image(systemName: "heart.fill")
                .foregroundColor(self.isBookmarked ? .accentColor : .gray)
        }
    }
    
}

private struct DreamTitleView : View{
    @Binding var title: String
    var body: some View{
        TextField("Title", text: $title)
    }
}

private struct DreamDeleteView : View{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    let dream : Dream?
    
    var body : some View{
        Button(action:deleteDream){
            Image(systemName: "trash.fill")
                .foregroundColor(.red)
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

private struct DreamBackView : View {
    @Environment(\.presentationMode) var presentationMode
    
    var body : some View{
        Button(action:backButtonPress){
            Image(systemName: "chevron.left")
        }
    }
    
    func backButtonPress(){
        self.presentationMode.wrappedValue.dismiss()
    }
}

private struct DreamTextView : View{
    @Binding var text: String
    var body: some View{
        MultilineTextField(placeholder: "The journey begins here", text: $text)
    }
}

private struct DreamSaveView : View{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    let title : String
    let text : String
    let isBookmarked : Bool
    let date : Date
    let tags : [Tag]
    
    var body : some View{
        Button(action: saveDream){
            Image(systemName: "tray.and.arrow.down.fill")
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
}

private struct DreamUpdateView : View{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    let dream : Dream?
    let title : String
    let text : String
    let isBookmarked : Bool
    let date : Date
    let tags : [Tag]
    
    var body : some View{
        Button(action: updateDream){
            Image(systemName: "tray.and.arrow.down.fill")
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
}

private struct DreamAddTagView : View {
    @Environment(\.managedObjectContext) var moc
    @Binding var tags : [Tag]
    @State var text : String = ""
    var body : some View{
        HStack{
            TextField("tag" , text: $text)
            Button(action: {self.addTag()}){
                Image(systemName: "plus")
            }
        }
    }
    
    func addTag(){
        if text.isEmpty{
            return
        }
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
        
        text = ""
    }
}

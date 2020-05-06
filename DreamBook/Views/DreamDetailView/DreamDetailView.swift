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
    @EnvironmentObject var theme : Theme
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
        ZStack{
            theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
            VStack{
                HStack(alignment : .bottom,spacing : self.theme.mediumPadding){
                    DreamBackView()
                    Spacer()
                    DimissKeyboardButton()
                    if isNewDream{
                        DreamSaveView(title: title, text: text, isBookmarked: isBookmarked, date: date, tags: tags)
                    }else{
                        DreamUpdateView(dream: dream, title: title, text: text, isBookmarked: isBookmarked, date: date, tags: tags)
                    }
                    if !isNewDream{
                        DreamDeleteView(dream: dream)
                    }
                    DreamBookmarkedView(isBookmarked: $isBookmarked)
                }.padding(.vertical,self.theme.smallPadding)
                ScrollView(.vertical, showsIndicators: false){
                    VStack(alignment : .leading){
                        DreamTitleView(title: $title)
                        TagCollectionView(tags: $tags)
                        DreamTextView(text: $text)
                    }
                }.navigationBarTitle("",displayMode: .inline)
                    .navigationBarHidden(true)
            }.padding(.horizontal, self.theme.mediumPadding)
        }
    }
}

struct DreamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailView()
    }
}

private struct DreamBookmarkedView : View{
    @Binding var isBookmarked: Bool
    @EnvironmentObject var theme : Theme
    var body : some View{
        Button(action:{
            self.isBookmarked.toggle()
        }){
            Image(systemName: "heart.fill")
                .foregroundColor(self.isBookmarked ? theme.primaryColor : theme.passiveColor)
        }
    }
}

private struct DreamTitleView : View{
    @EnvironmentObject var theme : Theme
    @Binding var title: String
    var body: some View{
        TextField("Title", text: $title).foregroundColor(theme.textTitleColor).font(.headline)
    }
}

private struct DreamDeleteView : View{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var theme : Theme
    
    let dream : Dream?
    
    var body : some View{
        Button(action:deleteDream){
            Image(systemName: "trash.fill")
                .foregroundColor(theme.tertiaryColor)
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
    @EnvironmentObject var theme : Theme
    
    var body : some View{
        Button(action:backButtonPress){
            Image(systemName: "chevron.left").foregroundColor(theme.primaryColor)
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
    @EnvironmentObject var theme : Theme
    
    let title : String
    let text : String
    let isBookmarked : Bool
    let date : Date
    let tags : [Tag]
    
    var body : some View{
        Button(action: saveDream){
            Image(systemName: "tray.and.arrow.down.fill").foregroundColor(theme.secundaryColor)
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
    @EnvironmentObject var theme : Theme
    
    let dream : Dream?
    let title : String
    let text : String
    let isBookmarked : Bool
    let date : Date
    let tags : [Tag]
    
    var body : some View{
        Button(action: updateDream){
            Image(systemName: "tray.and.arrow.down.fill").foregroundColor(theme.secundaryColor)
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


struct DimissKeyboardButton : View {
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    var body: some View{
        Button(action:{
            self.keyboardObserver.dismissKeyboard()
        }){
            Image(systemName: "keyboard.chevron.compact.down").foregroundColor(.white)
        }
    }
}

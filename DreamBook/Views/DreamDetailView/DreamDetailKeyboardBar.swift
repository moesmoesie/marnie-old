//
//  DreamDetailKeyboardBar.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailKeyboardBar: View {
    @Binding var tags : [Tag]
    @State var showSuggestionTags = false
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var theme : Theme
    var body: some View {
        VStack(spacing : 0){
            if showSuggestionTags{
                SuggestionTags(currentTags: $tags)
            }
            MenuView(showSuggestionTags: $showSuggestionTags, tags: $tags)
        }.padding(.bottom, keyboardObserver.heightWithoutSaveArea)
    }
}

struct MenuView : View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var theme : Theme
    @Binding var showSuggestionTags : Bool
    @Binding var tags : [Tag]
    

    var body: some View{
        HStack(alignment: .center){
            if(showSuggestionTags){
                AddTagTextField(tags: $tags)
            }
            Spacer()
            ActivateTagAddButton(showSuggestionTags: self.$showSuggestionTags)
            DimissKeyboardButton()
        }.background(showSuggestionTags ? theme.primaryBackgroundColor : .clear)
    }
}


private struct SuggestionTags : View {
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var tags : FetchedResults<Tag>
    @EnvironmentObject var theme : Theme
    @Environment(\.managedObjectContext) var moc
    @Binding var currentTags : [Tag]
    
    
    var tagsToShow : [Tag]{
        var tempTags : [Tag] = []
        for tag in tags{
            if !tempTags.contains(where: {$0.wrapperText == tag.wrapperText}){
                tempTags.append(tag)
            }
        }
        
        return tempTags
    }
    
    var body: some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                ForEach(tagsToShow, id: \.self){ (tag:Tag) in
                    TagView(tag: tag)
                        .onTapGesture {
                            self.addTag(text: tag.wrapperText)
                    }
                }
            }.padding(.horizontal, theme.mediumPadding)
            .padding(.bottom, theme.smallPadding)
        }
    }
    
    func addTag(text : String){
        if text.isEmpty{
            return
        }
        let tagService = TagService(managedObjectContext: self.moc)
        
        do{
            let tag = try tagService.createTag(text: text)
            if currentTags.contains(where: {$0.wrapperText == tag.wrapperText}){
                return
            }
            currentTags.append(tag)
        }catch{
            print("Cant create that tag")
        }
    }
}

private struct DimissKeyboardButton : View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    var body: some View{
        Button(action:{
            self.keyboardObserver.dismissKeyboard()
        }){
            Image(systemName: "keyboard.chevron.compact.down").foregroundColor(.white)
                .padding(.vertical, theme.smallPadding * 1.2 )
                .padding(.horizontal, theme.mediumPadding)
        }
    }
}

private struct ActivateTagAddButton : View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @Binding var showSuggestionTags: Bool
    var body: some View{
        Button(action:{
            self.showSuggestionTags.toggle()
        }){
            Image(systemName: "tag.fill").foregroundColor(self.showSuggestionTags ? self.theme.primaryColor : .white)
                .padding(.vertical, theme.smallPadding * 1.2)
        }
    }
}

private struct AddTagTextField : View {
    @State var text : String = ""
    @Binding var tags : [Tag]
    @EnvironmentObject var theme : Theme
    @Environment(\.managedObjectContext) var moc

    var body: some View{
        TextField("New Tag", text: $text,onCommit: {
            self.addTag(text: self.text)
        })
        .disableAutocorrection(true)
        .foregroundColor(theme.textTitleColor)
        .font(.caption)
        .padding(.leading, theme.mediumPadding)
    }
    
    func addTag(text : String){
           if text.isEmpty{
               return
           }
           let tagService = TagService(managedObjectContext: self.moc)
           
           do{
               let tag = try tagService.createTag(text: text)
               if tags.contains(where: {$0.wrapperText == tag.wrapperText}){
                   return
               }
               tags.append(tag)
           }catch{
               print("Cant create that tag")
           }
       }
}

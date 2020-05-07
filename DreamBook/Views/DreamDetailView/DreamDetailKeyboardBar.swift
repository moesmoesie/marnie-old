//
//  DreamDetailKeyboardBar.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailKeyboardBar: View {
    @State var showSuggestionTags = false
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var theme : Theme
    var body: some View {
        VStack(spacing : 0){
            if showSuggestionTags{
                SuggestionTags()
            }
            MenuView(showSuggestionTags: $showSuggestionTags)
        }.padding(.bottom, keyboardObserver.heightWithoutSaveArea)
    }
}

private struct MenuView : View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    @Binding var showSuggestionTags : Bool
    
    
    var body: some View{
        HStack(alignment: .center){
            if showSuggestionTags{
                AddTagTextField()
            }
            Spacer()
            ActivateTagAddButton(showSuggestionTags: self.$showSuggestionTags)
            DimissKeyboardButton()
        }
    }
}

private struct SuggestionTags : View {
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var tags : FetchedResults<Tag>
    @EnvironmentObject var theme : Theme
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dream : DreamViewModel
    
    
    var tagsToShow : [TagViewModel]{
        var tempTags : [TagViewModel] = []
        for tag in tags{
            let tagViewModel = TagViewModel(tag: tag)
            if !dream.tags.contains(where : {$0.text == tagViewModel.text}){
                if !tempTags.contains(where: {$0.text == tagViewModel.text}){
                    tempTags.append(tagViewModel)
                }
            }
        }
        
        return tempTags
    }
    
    var body: some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                ForEach(tagsToShow){ (tag:TagViewModel) in
                    TagView(tag: tag)
                        .onTapGesture {
                            self.addTag(text: tag.text)
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
        
        let tag = TagViewModel(text: text)
        
        if self.dream.tags.contains(where: {$0.text == tag.text}){
            return
        }
        
        self.dream.tags.append(tag)
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
    @EnvironmentObject var theme : Theme
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var dream : DreamViewModel
    
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
        
        let tag = TagViewModel(text: text)
        
        if self.dream.tags.contains(where: {$0.text == tag.text}){
            return
        }
        
        self.dream.tags.append(tag)
    }
}

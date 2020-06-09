//
//  FilterSheet.swift
//  DreamingJournals
//
//  Created by moesmoesie on 28/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData
import Combine


struct DreamDetailTagsSheet : View{
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var tagSuggestionObserver : TagSuggestionObserver
    @EnvironmentObject var dream : DreamViewModel
    @State var text: String = ""

    var body: some View{
        let tags = getTags()
        let screen = UIScreen.main.bounds
        return ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators : false){
                VStack(spacing : 0){
                    TopBar()
                        .padding(.bottom,.small)
                    
                    TagCreationField(text: $text)
                        .padding(.bottom,.small)
                    
                    if !dream.tags.isEmpty{
                        ActiveTags()
                            .padding(.bottom,.medium)
                    }
                    
                    if !tags.isEmpty{
                        SuggestionTags(tags: tags)
                    }
                    
                    Spacer().frame(height : screen.height / 2)
                }
            }.padding(.medium)
        }
    }
    
    func getTags() -> [TagViewModel]{
        var tags : [TagViewModel] = []
        for tag in tagSuggestionObserver.textSuggestionTags{
            let tagText =  tag.text.lowercased()
            if tagText.contains(text.lowercased()) || text.isEmpty{
                tags.append(tag)
            }
        }
        tags += tagSuggestionObserver.suggestionTags
        return tags.filter({!dream.tags.contains($0)})
    }
}

private struct SuggestionTags : View{
    let tags : [TagViewModel]
    @EnvironmentObject var dream : DreamViewModel

    var body: some View{
        return
            VStack(alignment: .leading, spacing: .extraSmall){
                title
                CollectionView(data: tags) { tag in
                    TagView(tag: tag)
                        .onTapGesture {
                            mediumFeedback()
                            withAnimation{
                                self.dream.tags.append(tag)
                            }
                    }
                }
            }
    }
    
    var title : some View{
        HStack(alignment:.bottom){
            Text("Suggestion Tags")
                .foregroundColor(.main1)
                .font(.secondaryLarge)

            Text("Tap to Add")
                .foregroundColor(.main2)
                .font(.primarySmall)
        }
    }
}

private struct TopBar : View{
    @EnvironmentObject var editorObserver : EditorObserver
    @EnvironmentObject var keyboardObserver : KeyboardObserver

    var body: some View{
        HStack(alignment: .firstTextBaseline){
            title
            Spacer()
            closeButton
        }
    }

    var closeButton : some View{
        Button(action: {
            mediumFeedback()
            self.keyboardObserver.dismissKeyboard()
            withAnimation(.timingCurve(0.4, 0.8, 0.2, 1, duration : 0.7)){
                self.editorObserver.currentMode = .regularMode
            }
        }){
            Image(systemName: "xmark.circle.fill")
            .font(.primaryLarge)
            .foregroundColor(.main1)
        }
    }

    var title : some View{
        Text("Tags")
            .font(.primaryLarge)
            .foregroundColor(.main1)
    }
}

private struct ActiveTags : View {
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        VStack(alignment: .leading, spacing : 0){
            title
                .padding(.bottom, .extraSmall)
            CollectionView(data: dream.tags){ tag in
                TagView(tag: tag)
                    .onTapGesture(perform: {self.onTagTap(tag)})
            }
        }
    }

    var title : some View{
        HStack(alignment:.bottom){
            Text("Active Tags")
                .foregroundColor(.main1)
                .font(.secondaryLarge)

            Text("Tap to delete")
                .foregroundColor(.main2)
                .font(.primarySmall)
        }
    }

    func onTagTap(_ tag : TagViewModel){
        mediumFeedback()
        withAnimation{
            if let index = self.dream.tags.firstIndex(of: tag){
                self.dream.tags.remove(at: index)
            }else{
                self.dream.tags.append(tag)
            }
        }
    }
}

private struct TagCreationField : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var tagSuggestionObserver : TagSuggestionObserver
    @EnvironmentObject var editorObserver : EditorObserver

    @Binding var text: String

    var body: some View{
        CustomTextField(
            text: $text,
            font: .primaryRegular,
            placeholder: "Create new Tag",
            placeholderFont: .primaryRegular,
            maxCharacters: 25,
            autoFocus: editorObserver.isInTagMode,
            onReturn: onReturn,
            onChange: onChange
        )
        .padding(.horizontal,.small)
        .padding(.vertical, .small)
        .background(Color.background2)
        .cornerRadius(12.5)
    }
    
    func onChange(textField : UITextField){
        tagSuggestionObserver.suggestionTags = tagSuggestionObserver.getUniqueTags(text: self.text)
    }

    
    func onReturn(textField : UITextField) -> Bool{
        self.text = self.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if self.text.isEmpty{
            return true
        }
        
        let tag = TagViewModel(text: self.text)
        self.text = ""
        tagSuggestionObserver.suggestionTags = tagSuggestionObserver.getUniqueTags(text: self.text)

        if dream.tags.contains(tag) || self.text.count > 25 {
            return true
        }
        
        withAnimation{
            self.dream.tags.append(tag)
        }
        
        return true
    }
}

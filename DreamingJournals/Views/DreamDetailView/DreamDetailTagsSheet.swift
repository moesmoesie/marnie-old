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



struct DreamDetailTagsSheet : View {
    var body: some View{
        CustomSheet(showFullScreen: true) {
            DreamDetailTagsSheetContent()
        }
    }
}

struct DreamDetailTagsSheetContent : View{
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var tagSuggestionObserver : TagSuggestionObserver

    var body: some View{
        ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            ScrollView(){
                VStack(spacing : 0){
                    TopBar()
                        .padding(.bottom,.small)
                    TagCreationField()
                        .padding(.bottom,.small)
                    ActiveTags()
                        .padding(.bottom,.medium)
                    if !tagSuggestionObserver.suggestionTags.isEmpty{
                        SuggestionTags()
                    }
                }
            }.padding(.medium)
        }
    }
}

private struct SuggestionTags : View{
    @EnvironmentObject var tagSuggestionObserver : TagSuggestionObserver
    @EnvironmentObject var dream : DreamViewModel

    var body: some View{
        let tags = tagSuggestionObserver.suggestionTags.filter({!dream.tags.contains($0)})
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

    @State var text: String = ""

    var body: some View{
        CustomTextField(
            text: $text,
            placeholder: "Create new tag",
            textColor: .main1,
            placeholderColor: .main2,
            tintColor: .accent1,
            maxCharacters: 25,
            font: .primaryRegular,
            onChange: onChange,
            onReturn: onReturn
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
        if self.text.isEmpty{
            return true
        }
        
        let tag = TagViewModel(text: self.text)
        self.text = ""
        if dream.tags.contains(tag) || self.text.count > 25 {
            return true
        }
        self.dream.tags.append(tag)
        
        return true
    }
}

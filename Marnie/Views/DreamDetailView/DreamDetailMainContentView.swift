//
//  DreamDetailMainContentView.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailMainContentView: View {
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var editorObserver : EditorObserver
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment : .leading, spacing:0){
                DreamDateView()
                    .padding(.top, .extraLarge)
                
                DreamTitleView()
                    .padding(.bottom, .extraSmall)
                
                if !self.dream.tags.isEmpty{
                    DreamTagCollectionView(tags: $dream.tags)
                    .padding(.bottom, .extraSmall)
                }
                DreamTextView()
            }
        }
    }
}

private struct DreamTagCollectionView : View{
    @Binding var tags : [TagViewModel]
    
    var body: some View{
        CollectionView(data: tags){(tag : TagViewModel) in
            TagView(tag: tag)
                .onTapGesture {
                    let index = self.tags.firstIndex(of: tag)!
                    self.tags.remove(at: index)
                }
        }
    }
}

private struct DreamTitleView : View{
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        CustomTextView(
            text: $dream.title,
            font: .primaryLarge,
            placeholder: "Title",
            placeholderFont: .primaryLarge,
            maxCharacters: 40,
            autoCorrect: false,
            autoFocus: dream.isNewDream,
            autoFocusDelay: 0.5,
            allowNewLine: false
        )
    }
}

private struct DreamTextView : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var tagSuggestionObserver : TagSuggestionObserver

    let bottomExtraClickableAreaHeight = UIScreen.main.bounds.height / 2
    var body: some View{
        CustomTextView(
            text: self.$dream.text,
            placeholder: "Begin your journey..",
            bottomExtraClickableAreaHeight: bottomExtraClickableAreaHeight,
            onChange: self.onChange
        )
    }
    
    func onChange(textView : UITextView){
        let location = textView.selectedRange.location
        let text = dream.text.prefix(location).suffix(100)
        tagSuggestionObserver.updateTagSuggestions(text: String(text))
    }
}

private struct DreamDateView : View{
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        Text(dream.wrapperDateString)
            .font(.primarySmall)
            .foregroundColor(.main2)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

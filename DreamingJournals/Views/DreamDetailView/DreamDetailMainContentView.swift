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
                KeyboardSpacer()
            }
        }
    }
}

private struct KeyboardSpacer : View{
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    
    var body: some View{
        Spacer()
            .frame(height : self.keyboardObserver.height < 500 ? 500 : self.keyboardObserver.heightWithoutSaveArea + 50)
    }
}

private struct DreamTagCollectionView : View{
    @Binding var tags : [TagViewModel]
    
    var body: some View{
        CollectionView(data: tags){(tag : TagViewModel) in
            TagView(tag: tag)
                .onTapGesture {
                    mediumFeedback()
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
            placeholder: "Title",
            placeholderColor: .main2,
            placeholderFont: .primaryLarge,
            textColor: .main1,
            tintColor: .accent1,
            font: .primaryLarge
        )
    }
}

private struct DreamTextView : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var editorObserver : EditorObserver
    
    var body: some View{
        CustomTextView(
            text: self.$dream.text,
            placeholder: "Begin your journey..",
            placeholderColor: .main2,
            cursorPosition: self.$editorObserver.cursorPosition,
            textColor: .main1,
            tintColor: .accent1,
            font: .primaryRegular
        )
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

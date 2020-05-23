//
//  DreamDetailMainContentView.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailMainContentView: View {
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    
    @EnvironmentObject var dream : DreamViewModel
    
    
    var body: some View {
        GeometryReader{ geo in
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment : .leading, spacing: .small * 0.8){
                    DreamDateView()
                    DreamTitleView()
                    if !self.dream.tags.isEmpty{
                        CollectionView(data: self.dream.tags){(tag : TagViewModel) in
                            TagView(tag: tag)
                                .onTapGesture {
                                    mediumFeedback()
                                    let index = self.dream.tags.firstIndex(of: tag)!
                                    self.dream.tags.remove(at: index)
                            }
                        }
                    }
                    DreamTextView()
                    Spacer()
                        .frame(height : self.keyboardObserver.height < 500 ? 500 : self.keyboardObserver.heightWithoutSaveArea + 50)
                }
            }
        }
    }
}

private struct DreamTitleView : View{
    
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        CustomTextField(
            text: $dream.title,
            placeholder: "Title",
            textColor: .main1, placeholderColor: .secondary,
            tintColor: .accent1,
            font: .primaryLarge
        ){textView in
            textView.resignFirstResponder()
            return true
        }
    }
}


private struct DreamTextView : View{
    @EnvironmentObject var dream : DreamViewModel
    
    @EnvironmentObject var editorObserver : EditorObserver

    var body: some View{
        CustomTextView(
            text: self.$dream.text,
            placeholder: "Begin your journey..",
            placeholderColor: .secondary,
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
            .foregroundColor(.accent1)
    }
}

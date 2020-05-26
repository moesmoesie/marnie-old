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
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment : .leading, spacing:0){
                DreamTitleView()
                    .padding(.top, .extraSmall)
                    .padding(.bottom, .extraSmall)
                if !self.dream.tags.isEmpty{
                    CollectionView(data: self.dream.tags){(tag : TagViewModel) in
                        TagView(tag: tag)
                            .onTapGesture {
                                mediumFeedback()
                                let index = self.dream.tags.firstIndex(of: tag)!
                                self.dream.tags.remove(at: index)
                        }
                    }.padding(.bottom, .extraSmall)
                }
                DreamTextView()
                Spacer()
                    .frame(height : self.keyboardObserver.height < 500 ? 500 : self.keyboardObserver.heightWithoutSaveArea + 50)
            }
        }
    }
}

private struct DreamTitleView : View{
    
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        CustomTextView(text: $dream.title, placeholder: "Title", placeholderColor: .main1, placeholderFont: .primaryLarge, textColor: .main1, tintColor: .accent1, font: .primaryLarge)
    }
}


private struct DreamTextView : View{
    @EnvironmentObject var dream : DreamViewModel
    
    @EnvironmentObject var editorObserver : EditorObserver
    
    var body: some View{
        CustomTextView(
            text: self.$dream.text,
            placeholder: "Begin your journey..",
            placeholderColor: Color.main1.opacity(0.7),
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
    }
}

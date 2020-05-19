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
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var navigationObserver : NavigationObserver
    
    
    var body: some View {
        GeometryReader{ geo in
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment : .leading, spacing: self.theme.smallPadding * 0.8){
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
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        CustomTextField(
            text: $dream.title,
            placeholder: "Title",
            textColor: theme.primaryTextUIColor,
            tintColor: theme.primaryAccentUIColor,
            font: theme.primaryLargeUIFont
        ){textView in
            textView.resignFirstResponder()
            return true
        }
    }
}


private struct DreamTextView : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var editorObserver : EditorObserver

    var body: some View{
        CustomTextView(
            text: self.$dream.text,
            placeholder: "Begin your journey..",
            cursorPosition: self.$editorObserver.cursorPosition,
            textColor: theme.primaryTextUIColor,
            tintColor: theme.primaryAccentTextUIColor,
            font: theme.primaryRegularUIFont
            
        )
    }
}

private struct DreamDateView : View{
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        Text(dream.wrapperDateString)
            .font(theme.primarySmallFont)
            .foregroundColor(theme.primaryAccentTextColor)
    }
}

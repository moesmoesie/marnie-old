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
    
    
    var body: some View {
        GeometryReader{ geo in
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment : .leading){
                    DreamDateView()
                    DreamTitleView()
                    TagCollectionView(self.dream, isEditable: true)
                        .frame(width: geo.size.width)
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
            textColor: theme.textTitleUIColor,
            tintColor: theme.primaryUIColor,
            font: .preferredFont(forTextStyle: .headline)
            ){textView in
                textView.resignFirstResponder()
                return true
        }
    }
}


private struct DreamTextView : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var theme : Theme

    var body: some View{
        CustomTextView(
            text: self.$dream.text,
            placeholder: "Begin your journey..",
            textColor: theme.secundaryUIColor,
            tintColor: theme.primaryUIColor,
            font: UIFont.preferredFont(forTextStyle: .body)
        )
    }
}

private struct DreamDateView : View{
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        Text(dream.wrapperDateString)
            .font(.caption)
            .foregroundColor(theme.primaryColor)
    }
}

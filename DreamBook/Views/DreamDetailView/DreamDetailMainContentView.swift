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
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment : .leading){
                DreamDateView()
                DreamTitleView()
                TagCollectionView(tags: self.$dream.tags)
                DreamTextView()
                Spacer()
                    .frame(height : keyboardObserver.height < 500 ? 500 : keyboardObserver.heightWithoutSaveArea + 50)
            }
        }
    }
}

private struct DreamTitleView : View{
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        TextField("Title", text: self.$dream.title).foregroundColor(theme.textTitleColor).font(.headline).accentColor(theme.primaryColor)
    }
}


private struct DreamTextView : View{
    @EnvironmentObject var dream : DreamViewModel

    var body: some View{
        MultilineTextField(placeholder: "The journey begins here", text: self.$dream.text)
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

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
    @Binding var title : String
    @Binding var text : String
    @Binding var isBookmarked : Bool
    @Binding var date : Date
    @Binding var tags : [Tag]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment : .leading){
                DreamDateView(date: date)
                DreamTitleView(title: $title)
                TagCollectionView(tags: $tags)
                DreamTextView(text: $text)
                Spacer()
                    .frame(height : keyboardObserver.height < 500 ? 500 : keyboardObserver.heightWithoutSaveArea + 50)
            }
        }
    }
}

private struct DreamTitleView : View{
    @EnvironmentObject var theme : Theme
    @Binding var title: String
    var body: some View{
        TextField("Title", text: $title).foregroundColor(theme.textTitleColor).font(.headline)
    }
}


private struct DreamTextView : View{
    @Binding var text: String
    var body: some View{
        MultilineTextField(placeholder: "The journey begins here", text: $text)
    }
}

private struct DreamDateView : View{
    @EnvironmentObject var theme : Theme
    let  date : Date
    var wrapperDateString : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    var body: some View{
        Text(wrapperDateString)
            .font(.caption)
            .foregroundColor(theme.primaryColor)
    }
}


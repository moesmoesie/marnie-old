//
//  DreamDetailView.swift
//  dream-book
//
//  Created by moesmoesie on 24/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    
    @State var title : String
    @State var text : String
    @State var isBookmarked : Bool
    @State var date : Date
    @State var tags : [Tag]
    
    var dream : Dream?
    
    var isNewDream : Bool{
        dream == nil
    }
    
    init(dream : Dream) {
        self.dream = dream
        _title = .init(initialValue: dream.wrappedTitle)
        _text = .init(initialValue: dream.wrappedText)
        _isBookmarked = .init(initialValue: dream.isBookmarked)
        _date = .init(initialValue: dream.wrapperDate)
        _tags = .init(initialValue: dream.wrappedTags)
    }
    
    init() {
        _title = .init(initialValue: "")
        _text = .init(initialValue: "")
        _isBookmarked = .init(initialValue: false)
        _date = .init(initialValue: Date())
        _tags = .init(initialValue: [])
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: theme.smallPadding){
                DreamDetailTopBar(isNewDream: isNewDream, title: $title, text: $text, isBookmarked: $isBookmarked, date: $date, tags: $tags, dream: dream)
                
                DreamDetailMainContentView(title: $title, text: $text, isBookmarked: $isBookmarked, date: $date, tags: $tags)
                
            }
            .padding(.horizontal, theme.mediumPadding)
            .navigationBarTitle("",displayMode: .inline)
            .navigationBarHidden(true)
            
            if keyboardObserver.isKeyboardShowing{
                DreamDetailKeyboardBar(tags: $tags)
            }
        }
    }
}


struct DreamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailView()
    }
}



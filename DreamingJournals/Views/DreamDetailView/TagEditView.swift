//
//  TagEditView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 18/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct TagEditView: View {
    
    @EnvironmentObject var editorObserver : EditorObserver
    @EnvironmentObject var keyboarObserver : KeyboardObserver
    @EnvironmentObject var dream : DreamViewModel
    @Environment(\.managedObjectContext) var moc
    let geo : GeometryProxy
    
    var tagsToShow : [TagViewModel]{
        let tagService = TagService(managedObjectContext: self.moc)
        let tags = tagService.getUniqueTags()
        var temp : [TagViewModel] = []
        for tag in tags{
            if !self.dream.tags.contains(tag){
                temp.append(tag)
            }
        }
        return temp
    }
    
    
    @State var tagText : String = ""
    var body: some View {
        VStack(spacing: 0){
            Color.background1.frame(height: getTopSaveArea())
            ScrollView{
                VStack(alignment : .leading, spacing: 0){
                    topBar
                        .padding(.bottom, .small)
                    textField
                        .padding(.bottom, .small)
                    currentTagsTitle
                        .padding(.bottom, .extraSmall)


                    if dream.tags.isEmpty{
                        placeHolderView
                    }else{
                        currentTags
                    }
                    availableTagsTitle
                        .padding(.bottom, .extraSmall)
                        .padding(.top, .small)
                    availableTags
                }
            }
            .padding(.horizontal, .medium)
            .frame(maxHeight : geo.size.height - self.keyboarObserver.height - .large * 2)
            .background(Color.background1)
            .cornerRadius(30, corners: [.bottomLeft,.bottomRight])
        }.edgesIgnoringSafeArea(.all)
    }
    
    //MARK:- HELPER VIEWS
    
    private var topBar : some View{
        HStack{
            Text("Tags")
                .foregroundColor(.primary)
                .font(Font.secondaryLarge)
                .padding(.top, .small)
            Spacer()
            self.closeButtonView
        }
    }
    
    private var currentTagsTitle : some View{
        HStack(alignment: .firstTextBaseline){
            Text("Current Tags")
                .font(Font.primaryLarge)
                .foregroundColor(.primary)
                .padding(.bottom, .extraSmall)
            
            if !self.dream.tags.isEmpty{
                Text("Tap to delete")
                    .font(.primarySmall)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var availableTagsTitle : some View{
        HStack{
            Text("Tag History")
                .font(Font.primaryLarge)
                .foregroundColor(.primary)
                .padding(.bottom, .extraSmall)
            Text("Tap to Add")
                .font(.primarySmall)
                .foregroundColor(.secondary)
        }
    }
    
    private var availableTags : some View{
        return  CollectionView(data: tagsToShow){tag in
            TagView(tag: tag).onTapGesture {
                mediumFeedback()
                self.dream.tags.append(tag)
            }
        }
    }
    
    private var currentTags : some View{
        VStack(alignment:.center){
            ZStack(alignment: .leading){
                self.placeHolderView
                    .padding(.top, .small)
                    .opacity(self.dream.tags.isEmpty ? 1 : 0)
                    .disabled(true)
                
                VStack{
                    CollectionView(data: self.dream.tags){(tag : TagViewModel) in
                        TagView(tag: tag).onTapGesture {
                            if let index = self.dream.tags.firstIndex(where: {tag.id == $0.id}){
                                mediumFeedback()
                                self.dream.tags.remove(at: index)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    private var placeHolderView : some View {
        Text("No Active Tags")
            .foregroundColor(.secondary)
            .opacity(0.5)
            .offset(x: 0, y: -.small)
    }
    
    private var textField : some View{
        CustomTextField(text: $tagText, placeholder: "Add new tag", focus: true, textColor: UIColor(named: "primary")!, placeholderColor : .secondary, tintColor: .primary ,font: .primaryRegular){_ in
            self.addTag(text: self.tagText)
            self.tagText = ""
            return true
        }
    }
    
    private var closeButtonView : some View{
        Button(action: {
            mediumFeedback()
            self.editorObserver.currentMode = .regularMode
        }){
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width : .large, height: .large)
                .foregroundColor(.accent2)
        }
    }
    
    //MARK:- Logic functions
    func addTag(text : String){
        if text.isEmpty{
            return
        }
        
        let tag = TagViewModel(text: text)
        
        if self.dream.tags.contains(where: {$0.text == tag.text}){
            return
        }
        
        self.dream.tags.append(tag)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

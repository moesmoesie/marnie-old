//
//  TagEditView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 18/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct TagEditView: View {
    @EnvironmentObject var theme : Theme
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
            theme.secondaryBackgroundColor.frame(height: getTopSaveArea())
            ScrollView{
                VStack(alignment : .leading, spacing: 0){
                    topBar
                        .padding(.bottom, theme.smallPadding)
                    textField
                        .padding(.bottom, theme.smallPadding)
                    currentTagsTitle
                        .padding(.bottom, theme.extraSmallPadding)


                    if dream.tags.isEmpty{
                        placeHolderView
                    }else{
                        currentTags
                    }
                    availableTagsTitle
                        .padding(.bottom, theme.extraSmallPadding)
                        .padding(.top, theme.smallPadding)
                    availableTags
                }
            }
            .padding(.horizontal, theme.mediumPadding)
            .frame(maxHeight : geo.size.height - self.keyboarObserver.height - theme.largePadding * 2)
            .background(theme.secondaryBackgroundColor)
            .cornerRadius(30, corners: [.bottomLeft,.bottomRight])
        }.edgesIgnoringSafeArea(.all)
    }
    
    
    
    
    //MARK:- HELPER VIEWS
    
    private var topBar : some View{
        HStack{
            Text("Tags")
                .foregroundColor(self.theme.primaryTextColor)
                .font(self.theme.secundaryLargeFont)
                .padding(.top, self.theme.smallPadding)
            Spacer()
            self.closeButtonView
        }
    }
    
    private var currentTagsTitle : some View{
        HStack(alignment: .firstTextBaseline){
            Text("Current Tags")
                .font(self.theme.primaryLargeFont)
                .foregroundColor(self.theme.primaryTextColor)
                .padding(.bottom, self.theme.extraSmallPadding)
            
            if !self.dream.tags.isEmpty{
                Text("Tap to delete")
                    .font(self.theme.primarySmallFont)
                    .foregroundColor(self.theme.placeHolderTextColor)
            }
        }
    }
    
    private var availableTagsTitle : some View{
        HStack{
            Text("Tag History")
                .font(self.theme.primaryLargeFont)
                .foregroundColor(self.theme.primaryTextColor)
                .padding(.bottom, self.theme.extraSmallPadding)
            Text("Tap to Add")
                .font(self.theme.primarySmallFont)
                .foregroundColor(self.theme.placeHolderTextColor)
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
                    .padding(.top, theme.smallPadding)
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
            .foregroundColor(theme.placeHolderTextColor)
            .opacity(0.5)
            .offset(x: 0, y: -theme.smallPadding)
    }
    
    private var textField : some View{
        CustomTextField(text: $tagText, placeholder: "Add new tag", focus: true, textColor: self.theme.primaryTextUIColor, placeholderColor : self.theme.placeHolderTextColor, tintColor: self.theme.primaryAccentUIColor ,font: theme.primaryRegularUIFont){_ in
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
                .frame(width : theme.largePadding, height: theme.largePadding)
                .foregroundColor(theme.secondaryAccentColor)
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

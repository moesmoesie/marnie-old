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
    let maxHeight : CGFloat
    
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
        ScrollView{
            VStack(alignment: .leading,spacing: 0){
                self.topBar
                    .padding(.bottom, self.theme.smallPadding)
                
                self.textField
                    .padding(.bottom, self.theme.smallPadding)
                
                self.currentTagsTitle
                self.currentTags
                    .padding(.bottom, self.theme.mediumPadding)
                
                if !self.tagsToShow.isEmpty{
                    self.availableTagsTitle
                    self.availableTags
                }}.animation(nil)
        }
        .frame(maxHeight: maxHeight - self.keyboarObserver.height - self.theme.largePadding * 3)
        .padding(.horizontal,self.theme.mediumPadding)
        .background(self.theme.primaryBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: self.theme.mediumPadding))
        .padding(.horizontal, self.theme.smallPadding)
        .padding(.bottom, self.theme.mediumPadding)
        .padding(.top, self.theme.smallPadding)
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

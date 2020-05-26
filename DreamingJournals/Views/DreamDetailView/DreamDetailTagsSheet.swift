//
//  DreamDetailTagsSheet.swift
//  DreamingJournals
//
//  Created by moesmoesie on 25/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailTagsSheet: View {
    @FetchRequest(entity: Tag.entity(),sortDescriptors: []) var fetchedTags: FetchedResults<Tag>
    var body: some View {
        ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            ScrollView(.vertical,showsIndicators: false){
                VStack(spacing : 0){
                    title
                        .padding(.bottom, .small)
                        .padding(.top, .medium)
                    
                    NewTagTextField()
                        .padding(.horizontal, .medium)
                        .padding(.bottom, .small)
                    
                    CurrentTags()
                        .frame(minHeight : 200, alignment: .top)
                        .padding(.horizontal, .medium)
                    
                    seperator
                    
                    
                    TagSuggestions(allTags: fetchedTags.map({TagViewModel(tag: $0)}))
                        .padding(.leading, .medium)
                        .padding(.top, .small)
                    
                    
                    Spacer(minLength: UIScreen.main.bounds.height / 2)
                }
            }
        }.frame(maxHeight: .infinity)
    }
    
    var seperator : some View{
        Rectangle()
            .foregroundColor(.background2)
            .frame(height: 1)
    }
    
    var title : some View{
        Text("Tags")
            .font(.primaryLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, .medium)
            .foregroundColor(.main1)
    }
}


struct DreamDetailTagsSheet_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailTagsSheet()
            .environmentObject(sampleData[0])
    }
}


struct NewTagTextField : View{
    @State var text : String = ""
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        CustomTextField(text: $text, placeholder: "New Tag", textColor: .main1, placeholderColor: .main2,tintColor: .accent1, maxCharacters: 25, font: .primaryRegular) { (view) -> Bool in
            let result = self.addTag(text: self.text)
            self.text = ""
            return result
        }.padding(.small)
            .background(Color.background2)
            .cornerRadius(.small)
    }
    
    func addTag(text : String) -> Bool{
        if text.isEmpty{
            return false
        }
        
        let tag = TagViewModel(text: text)
        
        if self.dream.tags.contains(where: {$0.text == tag.text}){
            return false
        }
        
        self.dream.tags.append(tag)
        return true
    }
}

struct CurrentTags : View {
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        VStack(spacing : 0){
            currentTagsTitle
                .padding(.bottom, .small)
            
            ZStack{
                if dream.tags.isEmpty{
                    Text("Your dream has no tags")
                        .font(.secondarySmall)
                        .foregroundColor(.main2)
                        .frame(height: 150, alignment: .center)
                }
                if !dream.tags.isEmpty{
                    CollectionView(data: dream.tags) {(tag : TagViewModel) in
                        TagView(tag: tag)
                            .onTapGesture {
                                if let index = self.dream.tags.firstIndex(of: tag){
                                    self.dream.tags.remove(at: index)
                                }
                        }
                    }
                }
            }
        }
    }
    
    var currentTagsTitle : some View{
        HStack(alignment: .lastTextBaseline){
            Text("Current Tags")
                .font(.secondaryLarge)
                .foregroundColor(.main1)
            
            if !dream.tags.isEmpty{
                Text("Tap to delete")
                    .font(.primarySmall)
                    .foregroundColor(Color.main1.opacity(0.3))
            }
            Spacer()
        }
    }
}

struct TagSuggestions : View {
    @EnvironmentObject var dream : DreamViewModel
    @State var tagSuggestions : [TagViewModel] = []
    
    var uniqueTags : [TagViewModel]
    
    init(allTags : [TagViewModel]) {
        var tempTags : [TagViewModel] = []
        for tag in allTags{
            if !tempTags.contains(tag){
                tempTags.append(tag)
            }
        }
        
        self.uniqueTags = tempTags
    }
    
    var body: some View{
        VStack (spacing : 0){
            if !tagSuggestions.isEmpty{
                tagSuggestionsTitle
                    .padding(.bottom, .small)
            }
            
            CollectionView(data: tagSuggestions){(tag: TagViewModel) in
                TagView(tag: tag)
                    .onTapGesture {
                        self.dream.tags.append(tag)
                }
            }
            
        }.onAppear(){self.onUpdate()}
            .onReceive(dream.$tags){ _ in
                self.onUpdate()
        }
    }
    
    var tagSuggestionsTitle : some View{
        HStack(alignment: .lastTextBaseline){
            Text("Tag Suggestions")
                .font(.secondaryLarge)
                .foregroundColor(.main1)
            
            Text("Tap to add")
                .font(.primarySmall)
                .foregroundColor(Color.main1.opacity(0.3))
            
            Spacer()
        }
    }
    
    func onUpdate(){
        for tag in uniqueTags{
            if !tagSuggestions.contains(tag){
                tagSuggestions.append(tag)
            }
        }
        
        for tag in dream.tags{
            if let index = tagSuggestions.firstIndex(of: tag){
                self.tagSuggestions.remove(at: index)
            }
        }
    }
    
    
}



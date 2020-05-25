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
            VStack(spacing : 0){
                title
                    .padding(.bottom, .small)
                    .padding(.top, .medium)
                
                
                CurrentTags()
                    .frame(minHeight : 200, alignment: .top)
                    .padding(.horizontal, .medium)
                
                
                seperator
                
                tagSuggestionsTitle
                    .padding(.leading, .medium)
                    .padding(.top, .medium)
                    .padding(.bottom, .small)
                
                TagSuggestions(allTags: fetchedTags.map({TagViewModel(tag: $0)}))
                    .padding(.leading, .medium)
                
                
                Spacer()
            }
        }
    }
    
    var seperator : some View{
        Rectangle()
            .foregroundColor(.background2)
            .frame(height: 1)
    }
    
    var title : some View{
        Text("Tags")
            .font(.secondaryLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, .medium)
            .foregroundColor(.main1)
    }
    
    var tagSuggestionsTitle : some View{
        Text("Tag Suggestions")
            .font(.primaryLarge)
            .foregroundColor(.main1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct DreamDetailTagsSheet_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailTagsSheet()
            .environmentObject(sampleData[0])
    }
}

struct CurrentTags : View {
    @EnvironmentObject var dream : DreamViewModel
    
    var body: some View{
        ZStack{
            if dream.tags.isEmpty{
                Text("Your dream has no tags")
                    .font(.secondarySmall)
                    .foregroundColor(.main2)
                    .frame(height: 150, alignment: .center)
                    .offset(y : -20)
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
        CollectionView(data: tagSuggestions){(tag: TagViewModel) in
            TagView(tag: tag)
                .onTapGesture {
                    self.dream.tags.append(tag)
            }
        }.onAppear(){self.onUpdate()}
            .onReceive(dream.$tags){ _ in
                self.onUpdate()
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



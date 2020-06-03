//
//  FilterSheet.swift
//  DreamingJournals
//
//  Created by moesmoesie on 28/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct DreamDetailTagsSheet: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var currentTags : [TagViewModel]
    @State var suggestionTags : [TagViewModel] = []
    @State var activeTags : [TagViewModel]
    @State var creationText : String = ""
    
    init(currentTags : Binding<[TagViewModel]>) {
        self._activeTags = .init(initialValue: currentTags.wrappedValue)
        self._currentTags = currentTags
    }
    
    var body: some View {
        let showSuggestions = !suggestionTags.filter({!activeTags.contains($0)}).isEmpty ||
        (creationText.isEmpty && activeTags.isEmpty)
        
        return ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(alignment: .leading,spacing : 0){
                    title
                    .padding(.top, .medium)
                    .padding(.bottom,.medium)
                    
                    TagCreationField(
                        text: $creationText,
                        currentTags: $currentTags,
                        onChange: onTagCreationChange,
                        onReturn: onTagCreationReturn
                    )
                    .padding(.bottom, .medium)
                    
                    if !activeTags.isEmpty{
                        ActiveTags(
                            currentTags: $currentTags,
                            activeTags :$activeTags
                        )
                        .padding(.bottom, .large)
                    }
                    
                    if showSuggestions{
                        SuggestionTags(
                            currentTags: $currentTags,
                            activeTags: $activeTags,
                            suggestionTags: $suggestionTags
                        )
                        .frame(minHeight: .extraLarge * 2, alignment: .top)
                    }
                }.padding(.horizontal, .medium)
            }
        }.onAppear{
            self.suggestionTags = self.getUniqueTags(text: "")
        }
    }
    
    var title : some View{
        Text("Tags")
            .font(.primaryLarge)
            .foregroundColor(.main1)
    }
    
    func onTagCreationChange(textField: UITextField){
        withAnimation{
            self.suggestionTags =  self.getUniqueTags(text: self.creationText)
        }
    }
    
    func onTagCreationReturn(textField: UITextField) -> Bool{
        withAnimation{
            self.addTag()
        }
        self.currentTags = self.activeTags
        return true
    }
    
    func addTag(){
        if self.creationText.isEmpty{
            return
        }
        
        let tag = TagViewModel(text: self.creationText)
        self.creationText = ""
        self.suggestionTags = getUniqueTags(text: "")
        if currentTags.contains(tag) || creationText.count > 25 {
            return
        }
        self.activeTags.append(tag)
    }
    
    func getUniqueTags(text : String) -> [TagViewModel]{
        let fetch : NSFetchRequest<NSDictionary> = Tag.uniqueTagTextFetch()
        fetch.fetchLimit = 50
        
        if !text.isEmpty{
            let predicate = NSPredicate(format: "text contains %@", text)
            fetch.predicate = predicate
        }
        
        do {
            let fetchedTags = try self.managedObjectContext.fetch(fetch)
            return fetchedTags.map({TagViewModel(text: $0["text"] as! String)})
        } catch {
            print("Error")
            return []
        }
    }
}

private struct ActiveTags : View {
    @Binding var currentTags : [TagViewModel]
    @Binding var activeTags : [TagViewModel]
    
    var body: some View{
        VStack(alignment: .leading, spacing : 0){
            title
                .padding(.bottom, .extraSmall)
            CollectionView(data: activeTags){ tag in
                TagView(tag: tag)
                    .onTapGesture(perform: {self.onTagTap(tag)})
            }
        }
    }
    
    var title : some View{
        HStack(alignment:.bottom){
            Text("Active Tags")
                .foregroundColor(.main1)
                .font(.secondaryLarge)
            
            Text("Tap to delete")
                .foregroundColor(.main2)
                .font(.primarySmall)
        }
    }
    
    func onTagTap(_ tag : TagViewModel){
        mediumFeedback()
        withAnimation{
            if let index = self.activeTags.firstIndex(of: tag){
                self.activeTags.remove(at: index)
            }else{
                self.activeTags.append(tag)
            }
        }
        self.currentTags = self.activeTags
    }
}

private struct SuggestionTags : View {
    @Binding var currentTags : [TagViewModel]
    @Binding var activeTags : [TagViewModel]
    @Binding var suggestionTags : [TagViewModel]
    
    var body: some View{
        let tags = suggestionTags.filter({!activeTags.contains($0)})
        return VStack(alignment:.leading,spacing: 0){
            title
                .padding(.bottom, .extraSmall)
            CollectionView(data: tags){ tag in
                TagView(tag: tag)
                    .onTapGesture {self.onTagTap(tag: tag)}
            }
        }
    }
    
    var title : some View{
        HStack{
            Text("Tag Suggestions")
                .foregroundColor(.main1)
                .font(.secondaryLarge)
            
            Text("Tap to add")
                .foregroundColor(.main2)
                .font(.primarySmall)
        }
    }
    
    func onTagTap(tag : TagViewModel){
        mediumFeedback()
        withAnimation{
            if let index = self.activeTags.firstIndex(of: tag){
                self.activeTags.remove(at: index)
            }else{
                self.activeTags.append(tag)
            }
        }
        self.currentTags = self.activeTags
    }
}


private struct TagCreationField : View{
    @Binding var text : String
    @Binding var currentTags : [TagViewModel]
    let onChange : (UITextField) -> ()
    let onReturn : (UITextField) -> (Bool)
    
    var body: some View{
        CustomTextField(
            text: $text,
            placeholder: "Create new tag",
            textColor: .main1,
            placeholderColor: .main2,
            tintColor: .accent1,
            maxCharacters: 25,
            font: .primaryRegular,
            onChange: self.onChange,
            onReturn: self.onReturn
        )
        .padding(.horizontal,.small)
        .padding(.vertical, .small)
        .background(Color.background2)
        .cornerRadius(12.5)
    }
}

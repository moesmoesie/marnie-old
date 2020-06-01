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
        return ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(alignment: .leading,spacing : 0){
                    title
                        .padding(.top, .medium)
                        .padding(.bottom,.small)
            
                    TagCreationField(text: $creationText, currentTags: $currentTags) {
                        self.suggestionTags =  self.getUniqueTags(text: self.creationText)
                    }.padding(.bottom, .medium)
                    
                    Tags(currentTags: $currentTags, activeTags :$activeTags,suggestionTags: $suggestionTags)
                
                    
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

private struct Tags : View {
    @Binding var currentTags : [TagViewModel]
    @Binding var activeTags : [TagViewModel]
    @Binding var suggestionTags : [TagViewModel]
    var tagsToShow : [TagViewModel]{
        var tags : [TagViewModel] = activeTags
        tags.append(contentsOf: suggestionTags.filter({!tags.contains($0)}))
        return tags
    }

    var body: some View{
        CollectionView(data: tagsToShow){ tag in
            TagView(
                tag: tag,
                isActive: self.activeTags.contains(tag)
            )
                .onTapGesture {
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
    }
}


private struct TagCreationField : View{
    @Binding var text : String
    @Binding var currentTags : [TagViewModel]
    let onChange : () -> ()
    
    var body: some View{
        CustomTextField(text: $text, placeholder: "Create new tag", textColor: .main1, placeholderColor: .main2, tintColor: .accent1, maxCharacters: 25, font: .primaryRegular,
                        onChange: { (textField) in
                            self.onChange()
                        }){ (textField) in
                            self.currentTags.append(TagViewModel(text: self.text))
                            self.text = ""
                            return true
                        }
        .padding(.horizontal,.small)
        .padding(.vertical, .small)
        .background(Color.background2)
        .cornerRadius(12.5)
    }
}

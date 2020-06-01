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

struct FilterSheet: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var keyboardObserver : KeyboardObserver

    @Binding var currentFilters : [FilterViewModel]
    @State var activeFilters : [FilterViewModel]
    @State var suggestionsTags : [TagViewModel] = []
    @State var searchText : String = ""
    
    init(initialFilters : Binding<[FilterViewModel]>) {
        _activeFilters = .init(initialValue: initialFilters.wrappedValue)
        self._currentFilters = initialFilters
    }
    
    var body: some View {
        return ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(alignment: .leading,spacing : 0){
                    title
                        .padding(.top, .medium)
                        .padding(.bottom,.small)
                    boolFilterButtons
                        .padding(.bottom,.small)
                    TagSearchTextField(text: $searchText, onChange: {
                        self.suggestionsTags = self.getUniqueTags(text: self.searchText)
                    })
                    Tags(activeFilters: $activeFilters, suggestionTags: $suggestionsTags)
                        .padding(.top, .medium)
                }.padding(.horizontal, .medium)
            }
            buttonsBar
        }.onAppear{
            self.suggestionsTags = self.getUniqueTags(text: "")
        }
    }
    
    var boolFilterButtons : some View{
        HStack (spacing : .medium){
            FilterButton(activeFilters: $activeFilters, iconName: "heart", filterViewModel: FilterViewModel(filter: .isBookmarked(true)))
            FilterButton(activeFilters: $activeFilters, iconName: "eye", filterViewModel: FilterViewModel(filter: .isLucid(true)))
            FilterButton(activeFilters: $activeFilters, iconName: "tropicalstorm", filterViewModel: FilterViewModel(filter: .isNightmare(true)))
        }
    }
    
    var buttonsBar : some View{
        HStack{
            if activeFilters.isEmpty || activeFilters == currentFilters{
                Spacer()
            }else{
                if currentFilters.isEmpty{
                    SaveFiltersButton(text: "Activate Filters"){
                        mediumFeedback()
                        self.currentFilters = self.activeFilters
                    }.transition(.offset(x: -UIScreen.main.bounds.width))
                }else{
                    SaveFiltersButton(text: "Update Filters"){
                        mediumFeedback()
                        self.currentFilters = self.activeFilters
                    }.transition(.offset(x: -UIScreen.main.bounds.width))
                }
            }
            
            if !currentFilters.isEmpty{
                DeleteFiltersButton{
                    mediumFeedback()
                    withAnimation{
                        self.activeFilters = []
                    }
                    self.currentFilters = []
                }.transition(.offset(x: 200))
            }
        }
        .animation(.easeInOut)
        .padding(.horizontal,.medium)
        .padding(.bottom, keyboardObserver.isKeyboardShowing ?  keyboardObserver.heightWithoutSaveArea + .small : 0)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    var title : some View{
        Text("Filters")
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

private struct FilterButton : View {
    @Binding var activeFilters : [FilterViewModel]
    let iconName : String
    let filterViewModel : FilterViewModel
    var body: some View{
        CustomIconButton(
            iconName: iconName,
            iconSize: .medium,
            isActive: activeFilters.contains(filterViewModel))
        {
            mediumFeedback()
            if let index = self.activeFilters.firstIndex(of: self.filterViewModel){
                self.activeFilters.remove(at: index)
            }else{
                self.activeFilters.append(self.filterViewModel)
            }
        }
    }
}


private struct Tags : View {
    @Binding var activeFilters : [FilterViewModel]
    @Binding var suggestionTags : [TagViewModel]
    var tagsToShow : [TagViewModel]{
        var tags : [TagViewModel] = []
        for filter in activeFilters{
            switch filter.filter {
            case let .tag(tag):
                tags.append(tag)
            default: break
            }
        }
        tags.append(contentsOf: suggestionTags.filter({!tags.contains($0)}))
        return tags
    }

    var body: some View{
        CollectionView(data: tagsToShow){ tag in
            TagView(
                tag: tag,
                isActive: self.activeFilters.contains(FilterViewModel(filter: .tag(tag)))
            )
                .onTapGesture {
                    withAnimation{
                        if let index = self.activeFilters.firstIndex(of: FilterViewModel(filter: .tag(tag))){
                            self.activeFilters.remove(at: index)
                        }else{
                            self.activeFilters.append(FilterViewModel(filter: .tag(tag)))
                        }
                    }
                }
        }
    }
}

private struct SaveFiltersButton : View{
    let text : String
    let onPress : () -> ()
    var body: some View{
        Button(action: onPress){
            Text(text)
                .foregroundColor(.main2)
        }
        .frame(maxWidth : .infinity)
        .frame(height: .extraLarge)
        .background(Color.background2)
        .cornerRadius(12.5)
    }
}

private struct DeleteFiltersButton : View{
    let onPress : () -> ()

    var body: some View{
        Button(action: onPress){
            Image(systemName: "trash")
                .foregroundColor(.red)
                .imageScale(.medium)
        }
        .frame(height: .extraLarge)
        .padding(.horizontal,.large)
        .background(Color.background1)
        .cornerRadius(12.5)
        .overlay(RoundedRectangle(cornerRadius: 12.5).stroke(Color.red, lineWidth: 1))
    }
}

private struct TagSearchTextField : View{
    @Binding var text : String
    let onChange : () -> ()
    
    var body: some View{
        CustomTextField(text: $text, placeholder: "Search for Tags", textColor: .main1, placeholderColor: .main2, tintColor: .accent1, maxCharacters: 25, font: .primaryRegular, onChange: { (textField) in
            self.onChange()
        })
        .padding(.horizontal,.medium)
        .padding(.vertical, .small)
        .background(Color.background2)
        .cornerRadius(12.5)
    }
}

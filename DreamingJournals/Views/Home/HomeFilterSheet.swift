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

struct HomeFilterSheet: View {
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
        return ZStack(alignment : .bottom){
            Color.background1.edgesIgnoringSafeArea(.all)
            ScrollView{
                mainContent
                    .padding(.horizontal, .medium)
            }
            FilterSheetKeyboardBar()
            bottomButtonsBar
        }.onAppear{
            self.suggestionsTags = self.getUniqueTags(text: "")
        }
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
    
    //MARK: - HELPER VIEWS
    
    var mainContent : some View{
        VStack(alignment: .leading,spacing : 0){
            title
                .padding(.top, .medium)
                .padding(.bottom,.small)
            
            boolFilterButtons
                .padding(.bottom,.small)
            
            WordFilterTextField(activeFilter: $activeFilters)
                .padding(.bottom,.medium)
            
            WordCollectionView(activeFilters: $activeFilters)
                .padding(.bottom,.medium)
            
            
            TagSearchTextField(text: $searchText, onChange: {
                self.suggestionsTags = self.getUniqueTags(text: self.searchText)
            })
            Tags(activeFilters: $activeFilters, suggestionTags: $suggestionsTags)
                .padding(.top, .medium)
        }
    }
    
    var boolFilterButtons : some View{
        HStack (spacing : .medium){
            FilterButton(activeFilters: $activeFilters, iconName: "heart", filterViewModel: FilterViewModel(filter: .isBookmarked(true)))
            FilterButton(activeFilters: $activeFilters, iconName: "eye", filterViewModel: FilterViewModel(filter: .isLucid(true)))
            FilterButton(activeFilters: $activeFilters, iconName: "tropicalstorm", filterViewModel: FilterViewModel(filter: .isNightmare(true)))
        }
    }
    
    var bottomButtonsBar : some View{
        VStack(spacing : .small){
            dreamCountBar
            filterActivationButtons
        }
        .animation(.easeInOut)
        .padding(.horizontal,.medium)
        .padding(.bottom, getBottomSaveArea() > 0 ? 0 : .medium )
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    var filterActivationButtons : some View{
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
    }
    
    var dreamCountBar : some View{
        HStack{
            Spacer()
            
            if activeFilters != currentFilters{
                Text("New Count : \(Dream.dreamCount(with: activeFilters, context: managedObjectContext)) ")
                    .frame(height : .extraLarge)
                    .truncationMode(.middle)
                    .foregroundColor(.main2)
                    .padding(.horizontal, .medium)
                    .background(Color.background2)
                    .cornerRadius(12.5)
            }
            
            Text("Count : \(Dream.dreamCount(with: currentFilters, context: managedObjectContext)) ")
                .frame(height : .extraLarge)
                .foregroundColor(.main2)
                .padding(.horizontal, .medium)
                .background(Color.background2)
                .cornerRadius(12.5)
        }
    }
    
    var title : some View{
        Text("Filters")
            .font(.primaryLarge)
            .foregroundColor(.main1)
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
                    mediumFeedback()
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

private struct WordFilterTextField : View{
    @State var text : String = ""
    @Binding var activeFilter : [FilterViewModel]
    var body: some View{
        CustomTextField(text: $text, placeholder: "Create a word filter", textColor: .main1, placeholderColor: .main2, tintColor: .accent1, maxCharacters: 25, font: .primaryRegular, onReturn: { (textField) in
            self.activeFilter.append(FilterViewModel(filter: .containsWord(self.text)))
            self.text = ""
            return true
        })
            .padding(.horizontal,.medium)
            .padding(.vertical, .small)
            .background(Color.background2)
            .cornerRadius(12.5)
    }
}

private struct WordCollectionView: View {
    @Binding var activeFilters : [FilterViewModel]
    
    var wordsFilters : [TagViewModel]{
        var tags : [TagViewModel] = []
        for filter in activeFilters{
            switch filter.filter {
            case let .containsWord(word):
                tags.append(TagViewModel(text: word))
            default: break
            }
        }
        return tags
    }
    
    var body: some View {
        return CollectionView(data: wordsFilters) { (wordTag : TagViewModel) in
            TagView(tag: wordTag, isActive:  true)
                .onTapGesture {
                    if let index = self.activeFilters.firstIndex(of: FilterViewModel(filter: .containsWord(wordTag.text))){
                        self.activeFilters.remove(at: index)
                    }
            }
        }
    }
}



private struct FilterSheetKeyboardBar: View {
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var editorObserver : EditorObserver
    
    var body: some View {
        return HStack(alignment: .center){
            Spacer()
            CustomPassiveIconButton(iconName: "chevron.down.square", iconSize: .small) {
                self.keyboardObserver.dismissKeyboard()
            }.padding(.trailing, .medium)
                .padding(.bottom, .small)
        }
        .padding(.bottom,keyboardObserver.isKeyboardShowing ?  keyboardObserver.heightWithoutSaveArea : 100)
        .opacity(keyboardObserver.isKeyboardShowing ? 1 : 0)
        .disabled(!keyboardObserver.isKeyboardShowing)
        .animation(.easeOut(duration: 0.4))
    }
}

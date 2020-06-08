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
            
            BottomBar(activeFilters: $activeFilters, currentFilters: $currentFilters)
                .padding(.horizontal, .medium)
                .padding(.bottom, getBottomSaveArea() > 0 ? 0 : .small)
            
            FilterSheetKeyboardBar(currentFilters: $currentFilters, activeFilters: $activeFilters)
        }.onAppear{
            self.suggestionsTags = self.getUniqueTags(text: "")
        }
    }
    
    var mainContent : some View{
        VStack(alignment: .leading,spacing : 0){
            TopBar(currentFilters: $currentFilters, activeFilters: $activeFilters)
                .padding(.top, .medium)
                .padding(.bottom,.small)
            
            BooleanButtonsBar(activeFilters: $activeFilters, currentFilters: $currentFilters)
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

private struct BooleanButtonsBar : View{
    @Binding var activeFilters : [FilterViewModel]
    @Binding var currentFilters : [FilterViewModel]
    
    var body: some View{
        HStack (spacing : .medium){
            FilterButton(activeFilters: $activeFilters, icon: Image.bookmarkIcon, filterViewModel: FilterViewModel(filter: .isBookmarked(true)))
            FilterButton(activeFilters: $activeFilters, icon: Image.lucidIcon, filterViewModel: FilterViewModel(filter: .isLucid(true)))
            FilterButton(activeFilters: $activeFilters, icon: Image.nightmareIcon, filterViewModel: FilterViewModel(filter: .isNightmare(true)))
        }
    }
}


private struct BottomBar : View{
    @Binding var activeFilters : [FilterViewModel]
    @Binding var currentFilters : [FilterViewModel]
    
    var body: some View{
        HStack{
            if activeFilters.isEmpty || activeFilters == currentFilters{
                Spacer()
            }else{
                if currentFilters.isEmpty{
                    SaveFiltersButton(text: "Activate Filters"){
                        mediumFeedback()
                        withAnimation{
                            self.currentFilters = self.activeFilters
                        }
                    }.transition(.offset(x: -UIScreen.main.bounds.width))
                }else{
                    SaveFiltersButton(text: "Update Filters"){
                        mediumFeedback()
                        withAnimation{
                            self.currentFilters = self.activeFilters
                        }
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
        }.animation(.easeInOut)
    }
}

private struct TopBar : View{
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    
    @Binding var currentFilters : [FilterViewModel]
    @Binding var activeFilters : [FilterViewModel]
    
    var body: some View{
        
        return HStack(alignment: .bottom, spacing: 0){
            title
                .animation(nil)
            Spacer()
            
            filterCount
                .padding(.leading, .small)
        }
    }
    
    
    var title : some View{
        Text("Filters")
            .font(.primaryLarge)
            .foregroundColor(.main1)
    }
    
    var filterCount : some View{
        let newFilterActive = activeFilters != currentFilters
        let dreamCount = Dream.dreamCount(with: activeFilters, context: managedObjectContext)
        
        return Text(" \(dreamCount) ")
            .frame(minWidth : .medium)
            .font(.secondaryRegular)
            .padding(.extraSmall)
            .background(newFilterActive ? Color.accent1 : Color.background2)
            .clipShape(RoundedRectangle(cornerRadius: 12.5))
            .foregroundColor(newFilterActive ? .main1  : .main2)
    }
}

private struct FilterButton : View {
    @Binding var activeFilters : [FilterViewModel]
    let icon : Image
    let filterViewModel : FilterViewModel
    var body: some View{
        CustomIconButton(
            icon: icon,
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
        Text(text)
            .foregroundColor(.main2)
            .frame(maxWidth : .infinity)
            .frame(height: .extraLarge)
            .background(Color.background2)
            .cornerRadius(12.5)
            .onTapGesture(perform: onPress)
    }
}

private struct DeleteFiltersButton : View{
    let onPress : () -> ()
    
    var body: some View{
            Image.trashIcon
                .foregroundColor(.red)
                .imageScale(.medium)
                .frame(height: .extraLarge)
                .padding(.horizontal,.large)
                .background(Color.background1)
                .cornerRadius(12.5)
                .overlay(RoundedRectangle(cornerRadius: 12.5).stroke(Color.red, lineWidth: 1))
                .onTapGesture(perform: onPress)
    }
}

private struct TagSearchTextField : View{
    @Binding var text : String
    let onChange : () -> ()
    
    var body: some View{
        CustomTextField(text: $text, placeholder: "Search for tags", maxCharacters: 25, onChange: {(_) in
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
        CustomTextField(
            text: $text,
            placeholder: "Create a word filter",
            maxCharacters: 25,
            onReturn: onReturn)
            .padding(.horizontal,.medium)
            .padding(.vertical, .small)
            .background(Color.background2)
            .cornerRadius(12.5)
    }
    
    func onReturn(textField : UITextField) -> Bool{
        self.activeFilter.append(FilterViewModel(filter: .containsWord(self.text)))
        self.text = ""
        return true
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
    @Binding var currentFilters : [FilterViewModel]
    @Binding var activeFilters : [FilterViewModel]
    
    var body: some View {
        return HStack(alignment: .center, spacing: .medium){
            Spacer()
            Group{
                if keyboardObserver.isKeyboardShowing{
                    if activeFilters != currentFilters{
                        if currentFilters.isEmpty{
                            activateButton
                                .transition(.offset(y: 50))
                        }else{
                            updateButton
                                .transition(.offset(y: 50))
                        }
                    }
                }
            }.animation(.easeInOut)
                .padding(.bottom, .small)
            
            
            CustomPassiveIconButton(icon: Image.dismissKeyboardIcon, iconSize: .small) {
                self.keyboardObserver.dismissKeyboard()
            }.padding(.trailing, .medium)
                .padding(.bottom, .small)
        }
        .padding(.bottom,keyboardObserver.isKeyboardShowing ?  keyboardObserver.heightWithoutSaveArea : 100)
        .opacity(keyboardObserver.isKeyboardShowing ? 1 : 0)
        .disabled(!keyboardObserver.isKeyboardShowing)
        .animation(.easeOut(duration: 0.4))
    }
    
    var updateButton : some View{
        Button(action: {
            mediumFeedback()
            self.currentFilters = self.activeFilters
        }){
            Text("Update")
                .frame(height: .medium * 1.8)
                .padding(.horizontal,.small * 1.5)
                .font(.secondaryRegular)
                .background(Color.background2)
                .foregroundColor(.main2)
                .clipShape(RoundedRectangle(cornerRadius: 12.5))
        }
    }
    
    var activateButton : some View{
        Button(action: {
            mediumFeedback()
            self.currentFilters = self.activeFilters
        }){
            Text("Activate")
                .frame(height: .medium * 1.8)
                .padding(.horizontal,.medium)
                .font(.secondaryRegular)
                .background(Color.background2)
                .foregroundColor(.main2)
                .clipShape(RoundedRectangle(cornerRadius: 12.5))
        }
    }
}

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
    @EnvironmentObject var filterObserver : FilterObserver
    @ObservedObject var filterSheetObserver : FilterSheetObserver = FilterSheetObserver()
    init(filters : [FilterViewModel]) {
        filterSheetObserver.activeFilters = filters
    }
    
    @State var isLoading = false
    var body: some View {
        return ZStack {
            Color.background1.edgesIgnoringSafeArea(.all)
            VStack(alignment : .leading, spacing: 0){
                Text(("Filters"))
                    .padding(.horizontal, .medium)
                    .padding(.top, .medium)
                    .foregroundColor(.main1)
                    .font(.primaryLarge)
                    .padding(.bottom, .small)
                FilterButtonRow()
                    .padding(.bottom, .medium)
                TagSearchField()
                    .padding(.bottom, .medium)
                Tags()
                    .padding(.horizontal, .medium)
                Spacer()
            }
            
            ActivateFiltersButton()
                .padding(.horizontal, .medium)
                .frame(maxHeight : .infinity,alignment: .bottom)
        }
        .environmentObject(filterSheetObserver)
    }
}

private struct Tags : View {
    @EnvironmentObject var filterSheetObserver : FilterSheetObserver
    var tagsToShow : [TagViewModel]{
        var tags : [TagViewModel] = []
        for filter in filterSheetObserver.activeFilters{
            switch filter.filter {
            case let .tag(filterTag):
                tags.append(filterTag)
            default: break
            }
        }
        
        for tag in filterSheetObserver.tagSuggestions{
            if !tags.contains(tag){
                tags.append(tag)
            }
        }
        
        return tags
    }
    
    
    var body: some View{
        return CollectionView(data: tagsToShow) { (tagViewModel :TagViewModel) in
            TagView(tag: tagViewModel,
                    isActive: self.filterSheetObserver.activeFilters.contains(FilterViewModel(filter: .tag(tagViewModel)))
            ).onTapGesture {
                let filter = FilterViewModel(filter: .tag(tagViewModel))
                
                if let index = self.filterSheetObserver.activeFilters.firstIndex(of: filter){
                    self.filterSheetObserver.activeFilters.remove(at: index)
                }else{
                    self.filterSheetObserver.activeFilters.append(filter)
                }
            }
        }
    }
}


struct TagSearchField : View{
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var filterSheetObserver : FilterSheetObserver

    var body: some View{
        CustomTextField(
            text: $filterSheetObserver.tagSuggestionText,
            placeholder: "Search For Tags",
            textColor: .main1,
            placeholderColor: .main2,
            tintColor: .accent1,
            maxCharacters: 25,
            font: .primaryRegular) { (view) -> Bool in
                self.filterSheetObserver.tagSuggestionText = ""
                return true
        }
        .padding(.small)
        .background(Color.background2)
        .cornerRadius(.small)
        .padding(.horizontal, .medium)
    }
}

private struct ActivateFiltersButton : View{
    @EnvironmentObject var filterSheetObserver : FilterSheetObserver
    @EnvironmentObject var filterObserver : FilterObserver

    var body: some View{
        Button(action:{
            self.filterObserver.filters = self.filterSheetObserver.activeFilters
          }){
              HStack{
                  Text("Activate Filters")
                    .foregroundColor(filterObserver.filters.isEmpty ? .main2 : .main1)
              }
          }
          .buttonStyle(PlainButtonStyle())
          .frame(maxWidth : .infinity)
          .padding(.medium)
        .background(filterObserver.filters.isEmpty ? Color.background2 : Color.accent1)
          .cornerRadius(12.5)
          .primaryShadow()
    }
}



private struct FilterButtonRow : View {
    var body: some View{
        HStack{
            FilterButton(iconName: "heart", filterViewModel: FilterViewModel(filter: .isBookmarked(true)))
            Spacer()
            FilterButton(iconName: "eye", filterViewModel: FilterViewModel(filter: .isLucid(true)))
            Spacer()
            FilterButton(iconName: "tropicalstorm", filterViewModel: FilterViewModel(filter: .isNightmare(true)))
        }.padding(.horizontal, .medium)
    }
}


private struct FilterButton : View {
    @EnvironmentObject var filterSheetObserver : FilterSheetObserver
    let iconName : String
    let filterViewModel : FilterViewModel
    var body: some View{
        CustomIconButton(
            iconName: iconName,
            iconSize: .medium,
            isActive: filterSheetObserver.activeFilters.contains(filterViewModel))
        {
            if let index = self.filterSheetObserver.activeFilters.firstIndex(of: self.filterViewModel){
                self.filterSheetObserver.activeFilters.remove(at: index)
            }else{
                self.filterSheetObserver.activeFilters.append(self.filterViewModel)
            }
        }
    }
}


class FilterSheetObserver : ObservableObject{
    @Published var activeFilters : [FilterViewModel] = []
    @Published var tagSuggestions : [TagViewModel] = []
    @Published var tagSuggestionText = ""
    var managedObjectContext : NSManagedObjectContext
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        self.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.managedObjectContext
        self.tagSuggestions = getUniqueTags(text: "")
        
        self.$tagSuggestionText
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { (text) in
                self.tagSuggestions = self.getUniqueTags(text: text)
        }.store(in: &cancellableSet)
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

//struct FilterSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterSheet()
//            .environmentObject(FilterObserver())
//    }
//}

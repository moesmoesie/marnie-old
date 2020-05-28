//
//  FilterSheet.swift
//  DreamingJournals
//
//  Created by moesmoesie on 28/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct FilterSheet: View {
    @EnvironmentObject var filterObserver : FilterObserver
    @EnvironmentObject var dreamStore : DreamStore
    var body: some View {
        return VStack{
            FilterButton(iconName: "eye", filterViewModel: FilterViewModel(filter: .isBookmarked(true)))
            Button("Activate"){

                self.activateFilters()
            }
        
        }
    }
    
    
    func activateFilters(){
        self.dreamStore.loadDreams(filterViewModels: self.filterObserver.filters)
    }
}


private struct FilterButton : View {
    @EnvironmentObject var filterObserver : FilterObserver
    let iconName : String
    let filterViewModel : FilterViewModel
    var body: some View{
        CustomIconButton(
        iconName: iconName,
        iconSize: .medium,
        isActive: filterObserver.filters.contains(filterViewModel))
        {
            if let index = self.filterObserver.filters.firstIndex(of: self.filterViewModel){
                self.filterObserver.filters.remove(at: index)
            }else{
                self.filterObserver.filters.append(self.filterViewModel)
            }
        }
    }
}






struct FilterSheet_Previews: PreviewProvider {
    static var previews: some View {
        FilterSheet()
    }
}

//
//  HomeView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct HomeContainer: View {
    @EnvironmentObject var filterObserver : FilterObserver
    var body: some View {
        return NavigationView{
            HomeFetchContainer(filters: filterObserver.filters)
        }
    }
}

private struct HomeFetchContainer: View {
    @ObservedObject var fetchObserver = FetchObserver()
    let filters : [FilterViewModel]
    
    var body: some View {
        return
            HomeContent(filters: filters, limit: fetchObserver.fetchlimit)
                .environmentObject(fetchObserver)
    }
}

private struct HomeContent : View{
    @Environment(\.managedObjectContext) var managedObjectContext
    var fetchRequest : FetchRequest<Dream>
    
    var fetchedResults : FetchedResults<Dream>{
        fetchRequest.wrappedValue
    }
    
    init(filters:[FilterViewModel], limit : Int) {
        self.fetchRequest = FetchRequest(fetchRequest: Dream.customFetchRequest(filterViewModels: filters, limit: limit))
    }
    
    var body: some View{
        return HomeView(dreams: fetchedResults)
            .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)) { (_) in
                Tag.deleteDreamlessTags(context: self.managedObjectContext)
            }
    }
}

class FetchObserver: ObservableObject {
    @Published var fetchlimit : Int = 100
    
    func incrementLimit(amount : Int = 100){
        fetchlimit += amount
    }
}

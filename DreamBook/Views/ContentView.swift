//
//  ContentView.swift
//  dream-book
//
//  Created by moesmoesie on 24/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(entity: Dream.entity(), sortDescriptors: []) var dreams : FetchedResults<Dream>
    @Environment(\.managedObjectContext) var moc
    @State var showNewDream = false
    
    var body: some View {
        return NavigationView {
            VStack {
                NavigationLink(
                    destination: DreamDetailView(),
                    isActive: $showNewDream
                ){
                    EmptyView()
                }
                List{
                    ForEach(dreams, id: \.self){ dream in
                        NavigationLink(
                            destination: DreamDetailView(dream: dream)
                        ){
                            HStack{
                                Text(dream.title ?? "No title")
                                if dream.isBookmarked{
                                    Spacer()
                                    Image(systemName: "heart")
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteDreams)
                }
                .navigationBarTitle("Dreams",displayMode: .inline)
                .navigationBarItems(trailing: Button("ADD"){
                    self.showNewDream = true
                }.padding())
            }
        }
    }
    
    func deleteDreams(at offsets : IndexSet){
        let dreamService = DreamService(managedObjectContext: self.moc)
        for offset in offsets{
            let dream = dreams[offset]
            do{
                try dreamService.deleteDream(dream)
            }catch{
                print("Error Deleting Dream")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, self.context)
    }
}

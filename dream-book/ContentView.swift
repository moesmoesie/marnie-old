//
//  ContentView.swift
//  dream-book
//
//  Created by moesmoesie on 24/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(entity: Dream.entity(), sortDescriptors: []) var dreams : FetchedResults<Dream>
    @Environment(\.managedObjectContext) var moc
    @State var showNewDream = false
    
    var body: some View {
        NavigationView {
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
                            Text(dream.title ?? "No title")
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
        for offset in offsets{
            let dream = dreams[offset]
            moc.delete(dream)
            try? moc.save()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

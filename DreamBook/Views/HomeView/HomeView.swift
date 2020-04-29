//
//  HomeView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView{
            DreamListView()
                .navigationBarTitle("Dreams")
                .navigationBarItems(trailing: AddDreamButton())
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct AddDreamButton : View {
    @State var showNewDream = false
    var body: some View{
        VStack{
            NavigationLink(destination: DreamDetailView(), isActive: $showNewDream){
                EmptyView()
            }
            Button(action:{
                self.showNewDream = true
            }){
                Image(systemName: "plus")
            }.padding()
        }
    }
}

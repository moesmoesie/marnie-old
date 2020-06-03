//
//  DreamListView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct HomeDreamListView : View {
    @EnvironmentObject var fetchObserver : FetchObserver
    var dreams: FetchedResults<Dream>
    
    var body: some View{
        return List{
            HomeDreamListHeaderView()
                .listRowInsets(EdgeInsets())
                .padding(.bottom, .medium)
            ForEach(dreams, id : \.self){ (dream : Dream) in
                HomeDreamListItemView(dream: dream)
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, .medium / 2)
                    .padding(.horizontal, .medium)
                    .onAppear{self.onDreamAppear(dream)}
            }
            Spacer(minLength: .navigationBarHeight * 1.5)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: onDreamListAppear)
    }
    
    func onDreamListAppear(){
        removeTableViewBackground()
    }
    
    func onDreamAppear(_ dream : Dream){
        if let lastDream = self.fetchObserver.lastDream{
            if dream == lastDream{
                DispatchQueue.main.async {
                    self.fetchObserver.incrementLimit()
                }
            }
        }
    }
}

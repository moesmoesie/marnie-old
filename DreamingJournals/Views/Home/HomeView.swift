//
//  HomeView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 24/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct HomeView: View {
    let dreams : [DreamViewModel]
    var body: some View {
        ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            DreamList(dreams: dreams)
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        removeTableViewBackground()
        return HomeView(dreams: sampleData)
    }
}

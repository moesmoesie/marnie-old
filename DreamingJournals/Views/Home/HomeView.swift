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
    let dreams : [Dream]
    var body: some View {
        ZStack(alignment: .bottom){
            Color.background1.edgesIgnoringSafeArea(.all)
            DreamList(dreams: dreams)
            MainNavigationBar()
        }.navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .onAppear{
            removeTableViewBackground()
        }
    }
}

//
//  HomeView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct HomeContainer: View {
    @EnvironmentObject var dreamStore : DreamStore
    var body: some View {
        return NavigationView{
            HomeView(dreams: dreamStore.dreams)
        }
    }
}



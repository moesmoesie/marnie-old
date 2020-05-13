//
//  HomeView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var navigationObserver : NavigationObserver
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .topLeading){
                theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
                DreamListView()
            }
            .onAppear(){
                withAnimation{
                    if !self.navigationObserver.showBottomBar{
                        self.navigationObserver.showBottomBar = true
                    }
                }
                
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

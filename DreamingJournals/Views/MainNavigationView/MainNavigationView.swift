//
//  MainNavigationView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 13/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct MainNavigationView: View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var navigationObserver : NavigationObserver
    var body: some View {
        ZStack(alignment:.bottom){
            if navigationObserver.currentPage == Pages.home{
                HomeView().padding(.bottom,  navigationObserver.showBottomBar ? getBottomSaveArea() : 0)
            }else if navigationObserver.currentPage == Pages.settings{
                theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
            }else if navigationObserver.currentPage == Pages.statistics{
                theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
            }
            
            VStack(spacing : 0){
                BottomAppBar()
                theme.primaryBackgroundColor.frame(height: getBottomSaveArea())
            }.offset(x: 0, y: navigationObserver.showBottomBar ? 0 : 100)
            .disabled(!navigationObserver.showBottomBar)
            .animation(.easeInOut)
        }.edgesIgnoringSafeArea(.bottom)
        
    }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
    }
}


private struct BottomAppBar : View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var navigationObserver : NavigationObserver

    var body : some View{
        return
            VStack(spacing: 0){
                Rectangle().frame(height: 0.2).foregroundColor(theme.passiveDarkColor)
                HStack{
                    Spacer()
                    BarButton(page: Pages.home, iconName: "house.fill")
                    Spacer()
                    Spacer()
                    BarButton(page: Pages.statistics, iconName: "chart.bar.fill")
                    Spacer()
                    Spacer()
                    BarButton(page: Pages.settings, iconName: "gear")
                    Spacer()
                }.padding(.vertical, theme.smallPadding * 1.2)
                    .background(theme.primaryBackgroundColor)
        }
    }
    
    func BarButton(page : Pages, iconName: String) -> some View {
        Button(action: {
            if self.navigationObserver.currentPage != page{
                self.navigationObserver.currentPage = page
            }
        }){
            Image(systemName: iconName).foregroundColor(navigationObserver.currentPage == page ? theme.primaryColor : theme.passiveLightColor)
        }
    }
}



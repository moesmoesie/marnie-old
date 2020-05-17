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
                SettingsView().padding(.bottom,  navigationObserver.showBottomBar ? getBottomSaveArea() : 0)
            }else if navigationObserver.currentPage == Pages.statistics{
                StatisticsView().padding(.bottom,  navigationObserver.showBottomBar ? getBottomSaveArea() : 0)
            }
            BottomAppBar()
        }.edgesIgnoringSafeArea(.bottom)
    }
}

//MARK: - BOTTOM APP BAR

private struct BottomAppBar : View {
    @EnvironmentObject var theme : Theme
    @EnvironmentObject var navigationObserver : NavigationObserver
    
    var body : some View{
        return
            VStack(spacing: 0){
                topBorder
                
                bottomBarcontent
                    .padding(.vertical, theme.smallPadding * 1.2)
                    .padding(.bottom, getBottomSaveArea())
                    .background(theme.primaryBackgroundColor)
                   
            }
            .offset(x: 0, y: navigationObserver.showBottomBar ? 0 : 100)
            .disabled(!navigationObserver.showBottomBar)
            .animation(.easeInOut)
    }
    
    var topBorder : some View{
        Rectangle()
            .frame(height: 0.2)
            .foregroundColor(theme.secondaryBackgroundColor)
    }
    
    var bottomBarcontent : some View{
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
        }
    }
    
    func BarButton(page : Pages, iconName: String) -> some View {
        let color = navigationObserver.currentPage == page ? theme.selectedColor : theme.unSelectedColor
        return Button(action: {
            if self.navigationObserver.currentPage != page{
                self.navigationObserver.currentPage = page
            }
        }){
            Image(systemName: iconName)
                .foregroundColor(color)
        }
    }
}

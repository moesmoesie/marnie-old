//
//  NavigationBar.swift
//  DreamingJournals
//
//  Created by moesmoesie on 26/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct MainNavigationView: View {
    @ObservedObject var navigationObserver = NavigationObserver()
    var body: some View {
        ZStack(alignment: .bottom){
            if navigationObserver.currentPage == Pages.home{
                HomeContainer()
            }
            
            if navigationObserver.currentPage == .settings{
                SettingsPage()
            }
            
            if navigationObserver.currentPage == Pages.statistics{
                StatisticsPage()
            }
            
            if navigationObserver.currentPage == Pages.profile{
                ProfilePage()
            }
        }.environmentObject(navigationObserver)
    }
}


struct MainNavigationBar: View {
    var isSaveArea : Bool{
        getBottomSaveArea() > 0
    }
    
    var body: some View {
            HStack{
                Spacer()
                
                BarButton(iconName: "house", page: Pages.home)
                
                Spacer()
                
                BarButton(iconName: "chart.bar", page: Pages.statistics)
                
                Group{
                    Spacer()
                    NewDreamButton(size: 50)
                    Spacer()
                }
                
                BarButton(iconName: "gear", page: .settings)
                
                Spacer()
                
                BarButton(iconName: "person.circle", page: .profile)
                Spacer()
            }
            .frame(height: .navigationBarHeight)
            .frame(maxWidth : .infinity)
            .padding(.bottom, isSaveArea ? getBottomSaveArea() : .small)
            .background(Color.background1.opacity(0.98))
            .cornerRadius(.medium)
            .offset(y : isSaveArea ? getBottomSaveArea()  * 1.5 : .small)
    }
    
    
    private struct BarButton : View{
        @EnvironmentObject var navigationObserver : NavigationObserver
        let iconName : String
        let page : Pages
        
        var body: some View{
            Image(systemName: iconName)
                .imageScale(.medium)
                .foregroundColor(navigationObserver.currentPage == page ? .main1 : .main2)
                .frame(width: .medium, height: .medium)
                .onTapGesture {
                    self.navigationObserver.setPage(page: self.page)
            }
        }
    }
    
    private struct NewDreamButton : View{
        let size : CGFloat
        @State var showNewDream : Bool = false

        var body: some View{
            ZStack{
                NavigationLink(destination: DreamDetailView(dream: DreamViewModel()), isActive: $showNewDream){
                    EmptyView()
                }.hidden()
                Image(systemName: "plus")
                    .imageScale(.large)
                    .frame(width: size , height: size)
                    .background(Color.accent1)
                    .foregroundColor(.main1)
                    .clipShape(Circle())
                    .onTapGesture {
                        self.showNewDream = true
                }
            }.frame(width :size ,height: size)
        }
    }
}


struct StatisticsPage : View {
    var body: some View{
        NavigationView{
            ZStack(alignment: .bottom){
                Color.background1.edgesIgnoringSafeArea(.all)
                MainNavigationBar()
            }
        }
    }
}

struct SettingsPage : View {
    var body: some View{
        NavigationView{
            ZStack(alignment: .bottom){
                Color.background1.edgesIgnoringSafeArea(.all)
                MainNavigationBar()
            }
        }
    }
}

struct ProfilePage : View {
    var body: some View{
        NavigationView{
            ZStack(alignment: .bottom){
                Color.background1.edgesIgnoringSafeArea(.all)
                MainNavigationBar()
            }
        }
    }
}

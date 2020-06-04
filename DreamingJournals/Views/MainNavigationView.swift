//
//  NavigationBar.swift
//  DreamingJournals
//
//  Created by moesmoesie on 26/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct MainNavigationView: View {
    @EnvironmentObject var navigationObserver : NavigationObserver
    @EnvironmentObject var settingsObserver : SettingsObserver

    var body: some View {
        ZStack(alignment: .bottom){
            if navigationObserver.currentPage == Pages.home{
                HomeContainer()
            }
            else if navigationObserver.currentPage == Pages.onboarding{
                OnboardingView()
                    .transition(.opacity)
            }
            else if navigationObserver.currentPage == Pages.settings{
                SettingsView()
            }
            else{
                ConstructionPage()
            }
        }.environmentObject(KeyboardObserver())
}
}


struct MainNavigationBar: View {
    
    var body: some View {
        HStack{
            Spacer()
            
            BarButton(icon: .homeIcon, page: Pages.home)
            
            Spacer()
            
            NewDreamButton(size: .extraLarge * 1.2)
            
            Spacer()
            
            BarButton(icon: .settingsIcon, page: .settings)
            
            Spacer()
            
            
        }
        .modifier(BottomBarStyling())
    }
    
    
    private struct BarButton : View{
        @EnvironmentObject var navigationObserver : NavigationObserver
        let icon : Image
        let page : Pages
        
        var body: some View{
            icon
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
        @EnvironmentObject var navigationObserver : NavigationObserver

        var body: some View{
            ZStack{
                NavigationLink(destination: LazyView(DreamDetailView().environmentObject(KeyboardObserver())), isActive: $navigationObserver.showNewDream){
                    EmptyView()
                }.hidden()
                Image.addDreamIcon
                    .imageScale(.large)
                    .frame(width: size , height: size)
                    .background(Color.accent1)
                    .foregroundColor(.main1)
                    .clipShape(Circle())
                    .onTapGesture {
                        mediumFeedback()
                        self.navigationObserver.showNewDream = true
                }
            }.frame(width :size ,height: size)
        }
    }
}


struct ConstructionPage : View {
    @EnvironmentObject var navigationObserver : NavigationObserver
    var message : String{
        switch navigationObserver.currentPage {
        case .profile:
            return "Profile"
        case .settings:
            return "Settings"
        case .statistics:
            return "Statistics"
        default:
            return "Construction"
        }
    }
    
    
    var body: some View{
        NavigationView{
            ZStack(alignment: .bottom){
                Color.background1.edgesIgnoringSafeArea(.all)
                VStack{
                    
                    Text(message)
                        .font(.primaryLarge)
                        .foregroundColor(.main1)
                    
                    Spacer()
                }
                LottieView(fileName: "construction")
                    .frame(maxWidth: .infinity)
                    .padding(.large)
                MainNavigationBar()
            }
        }
    }
}



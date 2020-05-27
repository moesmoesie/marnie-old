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
            }else{
                ConstructionPage()
            }
        }.environmentObject(navigationObserver)
    }
}


struct MainNavigationBar: View {
    
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
            .modifier(BottomBarStyling())
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
                NavigationLink(destination: LazyView(DreamDetailView(dream: DreamViewModel())), isActive: $showNewDream){
                    EmptyView()
                }.hidden()
                Image(systemName: "plus")
                    .imageScale(.large)
                    .frame(width: size , height: size)
                    .background(Color.accent1)
                    .foregroundColor(.main1)
                    .clipShape(Circle())
                    .onTapGesture {
                        mediumFeedback()
                        self.showNewDream = true
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



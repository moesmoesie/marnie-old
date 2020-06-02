//
//  OnboardingView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 02/06/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    @State var state = 1
    @EnvironmentObject var navigationObserver : NavigationObserver
    let screen = UIScreen.main.bounds
    var body: some View {
        ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            VStack{
                
                if state == 1{
                    text1
                        .padding(.top, screen.height / 4)
                        .transition(.asymmetric(insertion: .offset(x: screen.width), removal: .offset(x: -screen.width)))
                }
                
                if state == 2{
                    text2
                        .padding(.top, screen.height / 4)
                        .transition(.asymmetric(insertion: .offset(x: screen.width), removal: .offset(x: -screen.width)))
                }
                
                if state == 3{
                    text3
                        .padding(.top, screen.height / 4)
                        .transition(.asymmetric(insertion: .offset(x: screen.width), removal: .offset(x: -screen.width)))
                }
                
                
                Spacer()
                
            }.padding(.horizontal, .large)
                .animation(.spring())
            
            Button(action: {
                if self.state == 3{
                    self.navigationObserver.currentPage = .home
                }
                
                self.state += 1
            }){
                Text(state < 3 ? "Next" : "Start App")
                    .font(.secondaryLarge)
                    .foregroundColor(.main1)
            }.frame(maxWidth : .infinity, maxHeight:  .infinity, alignment: .bottomTrailing)
                .padding(.large)
        }
    }
    
    
    var text1 : some View{
        VStack{
            Text("Hello Dreamer!")
                .foregroundColor(.main1)
                .font(.primaryLarge)
            
            Text("Thank you for being part of the first round of beta testers. Your feedback is very much appreciated.")
                .foregroundColor(.main1)
                .font(.secondaryLarge)
                .multilineTextAlignment(.center)
            
            LottieView(fileName: "sleeping_animal")
                .offset(y: -.extraLarge * 2.2)
        }
    }
    
    var text2 : some View{
        VStack{
            Text("Symbols")
                .foregroundColor(.main1)
                .font(.primaryLarge)
            
            Text("Here are some of the symbols used throughout the app")
                .foregroundColor(.main1)
                .font(.secondaryLarge)
                .multilineTextAlignment(.center)
                .padding(.bottom, .large)
            
            
            VStack(alignment: .leading, spacing : .extraLarge){
                HStack{
                    CustomPassiveIconButton(iconName: "eye", iconSize: .medium)
                    Text("A Vivid/Lucid Dream")
                        .font(.secondaryLarge)
                        .foregroundColor(.white)
                }
                
                HStack{
                    CustomPassiveIconButton(iconName: "heart", iconSize: .medium)
                    Text("A Bookmarked Dream")
                        .font(.secondaryLarge)
                        .foregroundColor(.white)
                }
                
                HStack{
                    CustomPassiveIconButton(iconName: "tropicalstorm", iconSize: .medium)
                    Text("A Nightmare")
                        .font(.secondaryLarge)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    var text3 : some View{
        VStack{
            Text("Enjoy!")
                .foregroundColor(.main1)
                .font(.primaryLarge)
            
            LottieView(fileName: "milk_and_cookie")
                .offset(y: -.extraLarge * 2.2)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

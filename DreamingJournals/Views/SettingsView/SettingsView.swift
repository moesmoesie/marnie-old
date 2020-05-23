//
//  SettingsView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 13/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    
    var body: some View {
        ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(alignment : .center, spacing: 10){
                    HStack(alignment:.firstTextBaseline, spacing: .medium){
                        Text("Settings")
                            .font(Font.secondaryLarge)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    HStack{
                        Button(action:{
                            heavyFeedback()
                            print("Hello World")
                        }){
                            ZStack{
                                Rectangle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.accent1)
                                
                            }
                        }.buttonStyle(PlainButtonStyle())
                        Text("Darkmode")
                            .foregroundColor(.accent1)
                            .font(Font.primaryLarge)
                        Spacer()
                    }
                }.padding(.horizontal, .medium)
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

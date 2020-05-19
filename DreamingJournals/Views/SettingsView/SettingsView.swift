//
//  SettingsView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 13/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var theme : Theme
    
    var body: some View {
        ZStack{
            theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(alignment : .center, spacing: 10){
                    HStack(alignment:.firstTextBaseline, spacing: theme.mediumPadding){
                        Text("Settings")
                            .font(theme.secundaryLargeFont)
                            .foregroundColor(theme.primaryTextColor)
                        Spacer()
                    }
                    HStack{
                        Button(action:{
                            self.theme.darkMode.toggle()
                        }){
                            ZStack{
                                Rectangle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                if self.theme.darkMode{
                                    Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(theme.primaryAccentColor)
                                }
                            }
                        }.buttonStyle(PlainButtonStyle())
                        Text("Darkmode")
                            .foregroundColor(theme.primaryTextColor)
                            .font(theme.primaryLargeFont)
                        Spacer()
                    }
                }.padding(.horizontal, self.theme.mediumPadding)
            }
        }
    }
}
    
    
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
}

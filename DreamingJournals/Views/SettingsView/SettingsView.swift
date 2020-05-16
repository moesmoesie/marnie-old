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
            theme.backgroundColor.edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(alignment : .center, spacing: 10){
                    HStack(alignment:.firstTextBaseline, spacing: theme.mediumPadding){
                        Text("Settings").font(theme.secundaryLargeFont).foregroundColor(theme.textColor)
                        Spacer()
                    }
                    Toggle(isOn: self.$theme.darkMode){
                        Text("Darkmode").foregroundColor(self.theme.textColor)
                    }.accentColor(theme.primaryColor)
                }.padding(.horizontal, self.theme.mediumPadding)
            }
        }.onAppear{
            UISwitch.appearance().onTintColor = self.theme.primaryUIColor
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

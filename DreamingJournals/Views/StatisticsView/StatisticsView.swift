//
//  SettingsView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 13/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var theme : Theme
    
    var body: some View {
        ZStack{
            theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
            ScrollView{
                HStack(alignment:.firstTextBaseline, spacing: theme.mediumPadding){
                    Text("Statistics")
                        .font(theme.secundaryLargeFont)
                        .foregroundColor(theme.primaryTextColor)
                    Spacer()
                }
            }.padding(.horizontal, self.theme.mediumPadding)
        }
    }
}

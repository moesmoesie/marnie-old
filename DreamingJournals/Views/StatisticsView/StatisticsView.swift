//
//  SettingsView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 13/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
    
    
    var body: some View {
        ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            ScrollView{
                HStack(alignment:.firstTextBaseline, spacing: .medium){
                    Text("Statistics")
                        .font(Font.secondaryLarge)
                        .foregroundColor(Color.primary)
                    Spacer()
                }
            }.padding(.horizontal, .medium)
        }
    }
}

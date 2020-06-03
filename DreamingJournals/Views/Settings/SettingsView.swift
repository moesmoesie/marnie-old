//
//  SettingsView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 03/06/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State var enableReminders = false
    @State var reminderDate : Date = Date()
    var body: some View {
        NavigationView{
            ZStack{
                Color.background1.edgesIgnoringSafeArea(.all)
                Form{
                    Section{
                        Toggle(isOn: $enableReminders){
                            Text("Dream Reminders")
                                .foregroundColor(.main1)
                                .font(.secondaryLarge)
                        }
                        DatePicker(selection: $reminderDate, displayedComponents: .hourAndMinute){
                            Text("Reminder Time")
                                .foregroundColor(.main1)
                                .font(.secondaryLarge)
                        }.opacity(enableReminders ? 1 : 0)
                        .disabled(!enableReminders)
                    }.animation(.easeInOut)                    
                }.navigationBarTitle("Settings")
            }
        }.colorScheme(.dark)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

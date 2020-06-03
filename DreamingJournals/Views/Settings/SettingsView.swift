//
//  SettingsView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 03/06/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsObserver : SettingsObserver
    @State var showDatePicker : Bool = false
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottom){
                Color.background1.edgesIgnoringSafeArea(.all)
                Form{
                    Section{
                        Toggle(isOn: $settingsObserver.allowReminders){
                            Text("Dream Reminders")
                                .foregroundColor(.main1)
                                .font(.secondaryLarge)
                        }.alert(isPresented: $settingsObserver.showAlarm){
                            Alert(title: Text("Permission Needed"), message: Text("To set dream reminders you need to enable notifications for this app in the settings of your phone."))
                        }
                        DatePicker(selection: $settingsObserver.alarmTime, displayedComponents: .hourAndMinute){
                            Text("Reminder Time")
                                .foregroundColor(showDatePicker ? .main1 : .main2)
                                .font(.secondaryLarge)
                        }.opacity(showDatePicker ? 1 : 0)
                        .disabled(!showDatePicker)
                    }
                }.navigationBarTitle("Settings")
                MainNavigationBar()
            }.onReceive(settingsObserver.$allowReminders.debounce(for: 0.2, scheduler: RunLoop.main)){ (value) in
                withAnimation{
                    self.showDatePicker = value
                }
            }.onAppear{
                self.showDatePicker = self.settingsObserver.allowReminders
            }
        }.colorScheme(.dark)
    }
}

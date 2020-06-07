//
//  SettingsView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 03/06/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottom){
                Color.background1.edgesIgnoringSafeArea(.all)
                Form{
                    ExportSection()
                    ReminderSection()
                }.navigationBarTitle("Settings")
                MainNavigationBar()
            }
        }.colorScheme(.dark)
    }
}

struct ReminderSection : View {
    @State var showDatePicker : Bool = false
    @EnvironmentObject var settingsObserver : SettingsObserver

    var body: some View{
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
        .onReceive(settingsObserver.$allowReminders.debounce(for: 0.2, scheduler: RunLoop.main)){ (value) in
            withAnimation{
                self.showDatePicker = value
            }
        }.onAppear{
            self.showDatePicker = self.settingsObserver.allowReminders
        }
    }
}

struct ExportSection : View {
    @State var showShareSheet : Bool = false
    @Environment(\.managedObjectContext) var managedObjectContext
    
    func getData() -> Data{
        if let dreams = try? self.managedObjectContext.fetch(Dream.customFetchRequest()){
            let dreamViewModels = dreams.map({DreamViewModel(dream: $0)})
            return PDFCreator.createDreamsPDF(dreams: dreamViewModels)
        }
        else{
            return PDFCreator.createDreamsPDF(dreams: [])
        }
    }
    

    var body: some View{
        Section{
            Button(action:{
                self.showShareSheet = true
            }){
                Text("Export Dreams")
            }
        }
        .sheet(isPresented: $showShareSheet){
            ShareView(activityItems: [self.getData()])
        }
    }
}

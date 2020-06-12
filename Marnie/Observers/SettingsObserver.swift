//
//  SettingsObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 03/06/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import NotificationCenter
import Combine
class SettingsObserver : ObservableObject{
    @Published var allowReminders : Bool = false
    @Published var showAlarm : Bool = false
    @Published var alarmTime : Date
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var cancellableSet2: Set<AnyCancellable> = []

    init() {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        self.alarmTime = Calendar.current.date(from: components) ?? Date()
        
        if let date = getReminderStatus(){
            alarmTime = date
            allowReminders = true
        }else{
            allowReminders = false
        }
        
        $allowReminders.sink { (value) in
            let center = UNUserNotificationCenter.current()
            if value{
                center.getNotificationSettings { (settings) in
                    if settings.authorizationStatus == .notDetermined{
                        self.requestPermission()
                    } else if settings.authorizationStatus == .denied{
                        DispatchQueue.main.async {
                            self.allowReminders = false
                            self.showAlarm = true
                        }
                    }
                }
            }else{
                center.removeAllPendingNotificationRequests()
                self.writeReminderStatus(date: nil)
            }
        }.store(in: &cancellableSet)
            
        $alarmTime.sink { (date) in
            if self.allowReminders{
                self.setNotification(date: date)
                self.writeReminderStatus(date: date)
            }else{
                self.writeReminderStatus(date: nil)
            }
        }.store(in: &cancellableSet2)
    }
    
    func setNotification(date : Date){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized{
                let content = UNMutableNotificationContent()
                content.title = "Slide to write down your dream!"
                if settings.soundSetting == .enabled{
                    content.sound = UNNotificationSound.default
                }
                let calender = Calendar.current
                var dateComponents = DateComponents()
                dateComponents.hour = calender.component(.hour, from: date)
                dateComponents.minute = calender.component(.minute, from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
        }
    }
        
    func requestPermission(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound,.badge]) { granted, error in
            if let _ = error{
                return
            }
            
            DispatchQueue.main.async {
                self.allowReminders = granted
            }
        }
    }
    
    func checkForPermissionChanges(){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                let isAutorized = settings.authorizationStatus == .authorized
                if !isAutorized{
                    self.allowReminders = false
                    self.writeReminderStatus(date: nil)
                }
            }
        }
    }
    
    func writeReminderStatus(date : Date?){
        UserDefaults.standard.set(date, forKey: "alarmDate")
    }
    
    func getReminderStatus() -> Date?{
        let date = UserDefaults.standard.object(forKey: "alarmDate") as? Date
        return date
    }
}

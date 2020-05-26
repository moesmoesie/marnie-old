//
//  DreamDetailBottomBar.swift
//  DreamingJournals
//
//  Created by moesmoesie on 25/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailBottomBar: View {
    @EnvironmentObject var dream : DreamViewModel
    @EnvironmentObject var editorObserver : EditorObserver
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State var showSheet = false
    
    var body: some View {
        HStack{
            Group{
                Spacer()
                CustomIconButton(iconName: "heart", iconSize: .medium, isActive: dream.isBookmarked) {
                    self.toggle(value: self.$dream.isBookmarked)
                }
            }
            
            Group{
                Spacer()
                CustomIconButton(iconName: "eye", iconSize: .medium, isActive:  dream.isLucid) {
                    self.toggle(value: self.$dream.isLucid)
                }
            }
            
            Group{
                Spacer()
                CustomIconButton(iconName: "tropicalstorm", iconSize: .medium, isActive: dream.isNightmare) {
                    self.toggle(value: self.$dream.isNightmare)
                }
            }
            
            Group{
                Spacer()
                CustomIconButton(iconName: "tag", iconSize: .medium){
                    self.editorObserver.currentMode = Modes.tagMode
                }.sheet(isPresented: $showSheet, onDismiss: {
                    self.editorObserver.currentMode = Modes.regularMode
                }){
                    DreamDetailTagsSheet()
                        .environmentObject(self.dream)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                }
            }
            Group{
                Spacer()
                CustomIconButton(iconName: "trash", iconSize: .medium, action: self.deleteDream)
                Spacer()
            }
            
        }
            .onReceive(editorObserver.$currentMode) { (mode : Modes) in
                if mode == .tagMode{
                    self.showSheet = true
                }else{
                    self.showSheet = false
                }
        }
    }
    
    func toggle(value : Binding<Bool>){
        value.wrappedValue.toggle()
    }
    
    func deleteDream(){
        heavyFeedback()
        let dreamService = DreamService(managedObjectContext: self.managedObjectContext)
        try? dreamService.deleteDream(dream)
        presentationMode.wrappedValue.dismiss()
    }
}

struct BottomBarIcon: View{
    let iconName : String
    let isActive : Bool
    let action : () -> ()
    
    init(iconName: String, isActive : Bool, action : @escaping () -> ()) {
        self.iconName = iconName
        self.isActive = isActive
        self.action = action
    }
    
    var body: some View{
        Image(systemName: iconName)
            .imageScale(.medium)
            .foregroundColor(isActive ? .accent1 : .main1 )
            .shadow(color: isActive ? Color.accent1.opacity(0.3) : .clear, radius: 10, x: 0, y: 0)
            .frame(width: .extraLarge, height: .extraLarge)
            .background(Color.background3)
            .cornerRadius(10)
            .primaryShadow()
            .onTapGesture(perform: action)
    }
}

struct DreamDetailBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailBottomBar()
    }
}

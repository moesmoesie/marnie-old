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
        ZStack(alignment: .top){
            Rectangle()
                .foregroundColor(.background2)
                .frame(height: 1).opacity(0.3)
            HStack{
                Group{
                    Spacer()
                    BottomBarIcon(iconName: "heart", isActive: dream.isBookmarked){
                        self.toggle(value: self.$dream.isBookmarked)
                    }
                }
                
                Group{
                    Spacer()
                    BottomBarIcon(iconName: "eye", isActive: dream.isLucid){
                        self.toggle(value: self.$dream.isLucid)
                    }
                }
                
                Group{
                    Spacer()
                    BottomBarIcon(iconName: "tropicalstorm", isActive: dream.isNightmare){
                        self.toggle(value: self.$dream.isNightmare)
                    }
                }
                
                Group{
                    Spacer()
                    BottomBarIcon(iconName: "tag", isActive: false){
                        self.editorObserver.currentMode = Modes.tagMode
                    }.sheet(isPresented: $showSheet, onDismiss: {
                        self.editorObserver.currentMode = Modes.regularMode
                    }){
                        Text("Hello World")
                    }
                }
                Group{
                    Spacer()
                    BottomBarIcon(iconName: "trash", isActive: false, action: self.deleteDream)
                    Spacer()
                }
            }.padding(.top, .medium)
            .padding(.bottom, getBottomSaveArea() > 0 ? .small : .medium)
        }
        .padding(.bottom, getBottomSaveArea())
        .background(Color.background1)
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

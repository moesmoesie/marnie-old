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
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 2)
              .frame(maxHeight: .infinity)
              .frame(width : 0.5)
              .padding(.vertical, .medium)
              .foregroundColor(.main2)
            
            
            Group{
                Spacer()
                CustomIconButton(iconName: "tag", iconSize: .medium){
                    self.editorObserver.currentMode = Modes.tagMode
                }.sheet(isPresented: $showSheet, onDismiss: {
                    self.editorObserver.currentMode = Modes.regularMode
                }){
                    DreamDetailTagsSheet(currentTags: self.$dream.tags)
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
        try? Dream.deleteDream(dream, context: managedObjectContext)
        presentationMode.wrappedValue.dismiss()
    }
}

struct DreamDetailBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailBottomBar()
    }
}

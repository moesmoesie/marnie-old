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
    
    var body: some View {
        HStack{
            Spacer()
            
            toggleButtons
            
            Spacer()
            
            seperator
            
            Spacer()
           
            actionButtons
            
            Spacer()
        }
    }
    
    var toggleButtons : some View{
        Group{
            ToggleButton(value: $dream.isBookmarked, iconName: "heart")
            Spacer()
            ToggleButton(value: $dream.isLucid, iconName: "eye")
            Spacer()
            ToggleButton(value: $dream.isNightmare, iconName: "tropicalstorm")
        }
    }
    
    var seperator : some View{
        RoundedRectangle(cornerRadius: 2)
            .frame(maxHeight: .infinity)
            .frame(width : 0.5)
            .padding(.vertical, .medium)
            .foregroundColor(.main2)
    }
    
    var actionButtons : some View{
        Group{
            ActivateTagSheetButton()
            Spacer()
            DeleteDreamButton()
        }
    }
}

private struct ActivateTagSheetButton : View  {
    @EnvironmentObject var editorObserver : EditorObserver
    @EnvironmentObject var dream : DreamViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var showSheet : Bool = false
    
    var body: some View{
        CustomIconButton(iconName: "tag", iconSize: .medium){
            mediumFeedback()
            self.editorObserver.currentMode = Modes.tagMode
        }.sheet(isPresented: $showSheet, onDismiss: {
            self.editorObserver.currentMode = Modes.regularMode
        }){
            DreamDetailTagsSheet(currentTags: self.$dream.tags)
                .environmentObject(self.dream)
                .environment(\.managedObjectContext, self.managedObjectContext)
        }.onReceive(editorObserver.$currentMode) { (mode : Modes) in
            if mode == .tagMode{
                self.showSheet = true
            }else{
                self.showSheet = false
            }
        }
    }
}

private struct DeleteDreamButton : View{
    @EnvironmentObject var dream : DreamViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    var body: some View{
        CustomIconButton(
            iconName: "trash",
            iconSize: .medium,
            action: self.deleteDream
        )
    }
    
    func deleteDream(){
        heavyFeedback()
        try? Dream.deleteDream(dream, context: managedObjectContext)
        presentationMode.wrappedValue.dismiss()
    }
}

struct ToggleButton : View {
    @Binding var value : Bool
    let iconName : String
    
    var body: some View{
        CustomIconButton(iconName: iconName, iconSize: .medium, isActive: value) {
            mediumFeedback()
            self.value.toggle()
        }
    }
}

struct DreamDetailBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailBottomBar()
    }
}

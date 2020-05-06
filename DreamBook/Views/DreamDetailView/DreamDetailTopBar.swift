//
//  DreamDetailTopBar.swift
//  DreamBook
//
//  Created by moesmoesie on 06/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailTopBar: View {
    @EnvironmentObject var keyboardObserver : KeyboardObserver
    @EnvironmentObject var theme : Theme
    let isNewDream : Bool
    @Binding var title : String
    @Binding var text : String
    @Binding var isBookmarked : Bool
    @Binding var date : Date
    @Binding var tags : [Tag]
    var dream : Dream?
    
    var body: some View {
        HStack(alignment : .bottom,spacing : self.theme.mediumPadding){
            DreamBackView()
            Spacer()
            if isNewDream{
                DreamSaveView(title: title, text: text, isBookmarked: isBookmarked, date: date, tags: tags)
            }else{
                DreamUpdateView(dream: dream, title: title, text: text, isBookmarked: isBookmarked, date: date, tags: tags)
            }
            if !isNewDream{
                DreamDeleteView(dream: dream)
            }
            DreamBookmarkedView(isBookmarked: $isBookmarked)
        }.padding(.vertical, theme.smallPadding)
    }
}


private struct DreamDeleteView : View{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var theme : Theme
    
    let dream : Dream?
    
    var body : some View{
        Button(action:deleteDream){
            Image(systemName: "trash.fill")
                .foregroundColor(theme.tertiaryColor)
        }
    }
    
    func deleteDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        if let dreamToDelete = dream{
            do{
                try dreamService.deleteDream(dreamToDelete)
                presentationMode.wrappedValue.dismiss()
            }catch DreamService.DreamError.invalidDelete(error: let message){
                print(message)
            }catch{
                print("Unexpected error: \(error).")
            }
        }
    }
}

private struct DreamBackView : View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var theme : Theme
    
    var body : some View{
        Button(action:backButtonPress){
            Image(systemName: "chevron.left").foregroundColor(theme.passiveLightColor)
        }
    }
    
    func backButtonPress(){
        self.presentationMode.wrappedValue.dismiss()
    }
}



private struct DreamSaveView : View{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var theme : Theme
    
    let title : String
    let text : String
    let isBookmarked : Bool
    let date : Date
    let tags : [Tag]
    
    var body : some View{
        Button(action: saveDream){
            Image(systemName: "tray.and.arrow.down.fill").foregroundColor(theme.secundaryColor)
        }
    }
    
    func saveDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        do {
            try dreamService.saveDream(id : UUID(), title: title, text: text, isBookmarked: isBookmarked, date: date,tags: tags)
            presentationMode.wrappedValue.dismiss()
        } catch DreamService.DreamError.invalidSave(error: let message) {
            print(message)
        } catch{
            print("Unexpected error: \(error).")
        }
    }
}

private struct DreamUpdateView : View{
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var theme : Theme
    
    let dream : Dream?
    let title : String
    let text : String
    let isBookmarked : Bool
    let date : Date
    let tags : [Tag]
    
    var body : some View{
        Button(action: updateDream){
            Image(systemName: "tray.and.arrow.down.fill").foregroundColor(theme.secundaryColor)
        }
    }
    
    func updateDream(){
        let dreamService = DreamService(managedObjectContext: self.moc)
        if let dreamToUpDate = dream{
            do {
                try dreamService.updateDream(dreamToUpDate, title: title, text: text, isBookmarked: isBookmarked, date: date,tags: tags)
                presentationMode.wrappedValue.dismiss()
            } catch DreamService.DreamError.invalidUpdate(let message){
                print(message)
            } catch DreamService.DreamError.updatingNonExistingDream{
                print("Cant update a dream that doesn't exist!")
            } catch{
                print("Unexpected error: \(error).")
            }
        }else{
            print("Cant update a dream that doesnt exit!")
        }
    }
}

private struct DreamBookmarkedView : View{
    @Binding var isBookmarked: Bool
    @EnvironmentObject var theme : Theme
    var body : some View{
        Button(action:{
            self.isBookmarked.toggle()
        }){
            Image(systemName: "heart.fill")
                .foregroundColor(self.isBookmarked ? theme.primaryColor : theme.passiveDarkColor)
        }
    }
}


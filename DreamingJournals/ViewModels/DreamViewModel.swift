//
//  DreamViewModel.swift
//  DreamBook
//
//  Created by moesmoesie on 07/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation

class DreamViewModel : ObservableObject, Identifiable{
    @Published var id : UUID
    @Published var title : String
    @Published var text: String
    @Published var tags : [TagViewModel]
    @Published var date : Date
    @Published var isBookmarked : Bool
    @Published var isNewDream : Bool
    
    init(dream : Dream){
        self.id = dream.id!
        self.title = dream.wrappedTitle
        self.text = dream.wrappedText
        self.date = dream.wrapperDate
        self.isNewDream = false
        self.isBookmarked = dream.isBookmarked
        self.tags = []
        
        for tag in dream.wrappedTags{
            self.tags.append(TagViewModel(tag: tag))
        }

    }
    
    init(){
        self.title = ""
        self.text = ""
        self.tags = []
        self.date = Date()
        self.id = UUID()
        self.isBookmarked = false
        isNewDream = true
    }
    
    var wrapperDateString : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    init(id : UUID, title : String, text: String, tags: [TagViewModel], date : Date, isBookmarked : Bool, isNewDream : Bool ){
        self.id = id
        self.title = title
        self.text = text
        self.tags = tags
        self.date = date
        self.isBookmarked = isBookmarked
        self.isNewDream = isNewDream
    }
    
    func getCopy() -> DreamViewModel{
        DreamViewModel(id: self.id, title: self.title, text: self.text, tags: self.tags, date: self.date, isBookmarked: self.isBookmarked, isNewDream: self.isNewDream)
    }
}

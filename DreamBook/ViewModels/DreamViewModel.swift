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
    @Published var tags : [Tag]
    @Published var date : Date
    @Published var isBookmarked : Bool
    @Published var isNewDream : Bool
    
    init(dream : Dream){
        self.id = dream.id!
        self.title = dream.wrappedTitle
        self.text = dream.wrappedText
        self.tags = dream.wrappedTags
        self.date = dream.wrapperDate
        self.isNewDream = false
        self.isBookmarked = dream.isBookmarked
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
    
    private init(id : UUID, title : String, text: String, tags: [Tag], date : Date, isBookmarked : Bool, isNewDream : Bool ){
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

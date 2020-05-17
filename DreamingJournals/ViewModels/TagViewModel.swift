//
//  TagViewModel.swift
//  DreamBook
//
//  Created by moesmoesie on 07/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation

struct TagViewModel : Identifiable{
    let id = UUID()
    let text : String
    
    init(tag : Tag) {
        self.text = tag.wrapperText
    }
    
    init(text : String){
        self.text = text
    }
}


extension TagViewModel: Equatable {
    static func == (lhs: TagViewModel, rhs: TagViewModel) -> Bool {
        return lhs.text == rhs.text
    }
}




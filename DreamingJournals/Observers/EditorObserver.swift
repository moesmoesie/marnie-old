//
//  FilterObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import CoreData
import Combine

class EditorObserver : ObservableObject{
    @Published var currentMode : Modes{
        willSet{
            previousMode = currentMode
        }
    }
    
    var previousMode : Modes = .regularMode
    
    init() {
        self.currentMode = .regularMode
    }
    
    var isInTagMode : Bool{
        currentMode == Modes.tagMode
    }
}

enum Modes{
    case regularMode
    case tagMode
    case actionMode
}

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
    @Published var currentMode : Modes = .regularMode
    @Published var cursorPosition : Int = 0
    private var cancellableSet: Set<AnyCancellable> = []

    var isInTagMode : Bool{
        currentMode == Modes.tagMode
    }
}

enum Modes{
    case regularMode
    case tagMode
    case actionMode
}

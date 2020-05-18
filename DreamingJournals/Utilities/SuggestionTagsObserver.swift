//
//  SuggestionTagsObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 18/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import Combine
private var cancellableSet: Set<AnyCancellable> = []

class SuggestionTagsObserver : ObservableObject{
    @Published var text : String = ""
    @Published var tags : [TagViewModel] = []
    
    init() {
        self.$text.sink { (text) in
            print(text)
        }.store(in: &cancellableSet)
    }
}

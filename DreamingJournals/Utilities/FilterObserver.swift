//
//  FilterObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation

class FilterObserver : ObservableObject{
    @Published var tagFilters : [TagViewModel] = []
}

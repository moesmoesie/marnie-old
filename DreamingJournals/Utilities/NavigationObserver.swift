//
//  NavigationObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 13/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

class NavigationObserver : ObservableObject{
    @Published var currentPage = Pages.home
    @Published var showBottomBar = true
}

enum Pages {
    case home
    case settings
    case statistics
}

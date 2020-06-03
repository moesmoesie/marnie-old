//
//  NavigationObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 26/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation

class NavigationObserver : ObservableObject{
    @Published var currentPage = Pages.home
    @Published var showNewDream = false
    
    func setPage(page : Pages){
        if currentPage != page{
            currentPage = page
            mediumFeedback()
        }
    }
}

enum Pages{
    case home
    case settings
    case statistics
    case profile
    case onboarding
}

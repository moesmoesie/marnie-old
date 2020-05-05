//
//  Theme.swift
//  DreamBook
//
//  Created by moesmoesie on 05/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import SwiftUI

class Theme : ObservableObject {
    @Published var smallPadding : CGFloat = 10
    @Published var mediumPadding : CGFloat = 20
    @Published var largePadding : CGFloat = 30
    
    @Published var passiveColor : Color = Color(red: 46 / 255.0, green: 49 / 255.0, blue: 56/225.0)

    @Published var primaryColor : Color = Color(red: 226 / 255.0, green: 157 / 255.0, blue: 29/225.0)
    @Published var secundaryColor : Color = Color(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0)
    @Published var tertiaryColor : Color = Color.red
    
    @Published var primaryBackgroundColor : Color = Color(red: 22 / 255.0, green: 29 / 255.0, blue: 67/225.0)
    @Published var secundaryBackgroundColor : Color = Color(red: 31 / 255.0, green: 38 / 255.0, blue: 76/225.0)
    
    @Published var textTitleColor : Color = Color(red: 249 / 255.0, green: 249 / 255.0, blue: 249/225.0)
    @Published var textTitleUIColor : UIColor = UIColor(red: 249 / 255.0, green: 249 / 255.0, blue: 249/225.0, alpha: 1)

    @Published var textBodyColor : Color = Color(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0)
    @Published var textBodyUIColor : UIColor = UIColor(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0, alpha: 1)

}




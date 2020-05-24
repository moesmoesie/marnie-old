//
//  Gradients.swift
//  DreamingJournals
//
//  Created by moesmoesie on 24/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

extension Gradient{
    static func skyGradient(isDarkMode : Bool) -> Gradient{
        if isDarkMode{
            return Gradient(colors: [
                Color(red: 107 / 255.0, green: 110 / 255.0, blue: 112 / 255.0),
                Color(red: 44 / 255.0, green: 54 / 255.0, blue: 63 / 255.0),
                Color(red: 0 / 255.0, green: 0 / 255.0, blue: 5 / 255.0)
            ])
        }else{
            return Gradient(colors: [
                Color(red: 214 / 255.0, green: 182 / 255.0, blue: 48 / 255.0),
                Color(red: 219 / 255.0, green: 84 / 255.0, blue: 97 / 255.0),
            ])
        }
    }
}

//
//  Gradients.swift
//  DreamingJournals
//
//  Created by moesmoesie on 24/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

extension Gradient{
    static func skyGradient(darkMode: Bool, totalHeight: CGFloat, mainHeight: CGFloat) -> Gradient{
        let endMainLocation = mainHeight / totalHeight * 0.90
        if darkMode{
            return Gradient(stops: [
                Stop(color: Color(red: 69 / 255.0, green: 93 / 255.0, blue: 131 / 255.0), location: 0.0),
                Stop(color: Color(red:32 / 255.0, green: 47 / 255.0, blue: 86 / 255.0), location: endMainLocation * 0.4),
                Stop(color: Color(red:13 / 255.0, green: 17 / 255.0, blue: 32 / 255.0), location: endMainLocation),
                Stop(color: Color(red:9 / 255.0, green: 10 / 255.0, blue: 22 / 255.0), location: endMainLocation * 1.2),
                Stop(color: Color(red:3 / 255.0, green: 4 / 255.0, blue: 10 / 255.0), location: endMainLocation * 2.8),
            ])
        }else{
            return Gradient(stops: [
                Stop(color: Color(red: 214 / 255.0, green: 182 / 255.0, blue: 48 / 255.0), location: 0.0),
                Stop(color: Color(red: 219 / 255.0, green: 84 / 255.0, blue: 97 / 255.0), location: endMainLocation),
            ])
        }
    }
}

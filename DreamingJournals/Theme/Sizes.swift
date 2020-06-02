//
//  Sizes.swift
//  DreamingJournals
//
//  Created by moesmoesie on 23/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

extension CGFloat{
    static let screen = UIScreen.main.bounds
    static let iphoneXWidth : CGFloat = 414
    static var extraSmall : CGFloat{
        5 * (screen.width / iphoneXWidth)
    }
    
    static var small : CGFloat{
        10 * (screen.width / iphoneXWidth)
    }
    
    static var medium : CGFloat{
        20 * (screen.width / iphoneXWidth)
    }
    
    static var large : CGFloat{
        30 * (screen.width / iphoneXWidth)
    }
    
    static var extraLarge : CGFloat{
        40 * (screen.width / iphoneXWidth)
    }
    
    static var cardSize : CGFloat{
        300 * (screen.width / iphoneXWidth)
    }
    
    static var navigationBarHeight : CGFloat{
        .large * 2.2
    }
}

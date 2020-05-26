//
//  Colors.swift
//  DreamingJournals
//
//  Created by moesmoesie on 23/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

extension Color{
    static var main1 = Color("main1")
    static var main2 = main1.opacity(0.7)
    static var background1 = Color("background1")
    static var background2 = Color("background2")
    static var accent1 = Color("accent1")
}

extension UIColor{
    static var main1 = UIColor(named: "main1")!
    static var main2 = UIColor(named: "main1")!.withAlphaComponent(0.7)
    static var background1 = UIColor(named: "background1")!
    static var background2 = UIColor(named: "background2")!
    static var accent1 = UIColor(named: "accent1")!
}

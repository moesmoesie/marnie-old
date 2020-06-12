//
//  HapticFeedback.swift
//  DreamingJournals
//
//  Created by moesmoesie on 19/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

func mediumFeedback(){
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    impactMed.impactOccurred()
}

func heavyFeedback(){
    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
    impactMed.impactOccurred()
}

//
//  Shadows.swift
//  DreamingJournals
//
//  Created by moesmoesie on 24/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI


struct PrimaryShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(radius: .small)
    }
}

struct SecondaryShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.4), radius: .extraSmall / 1.5, x: .extraSmall / 2, y: .small / 3)
    }
}

extension View {
    func primaryShadow() -> some View {
        return self.modifier(PrimaryShadow())
    }
    
    func secondaryShadow() -> some View {
        return self.modifier(SecondaryShadow())
    }
}

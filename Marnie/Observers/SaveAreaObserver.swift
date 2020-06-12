//
//  SaveAreaObserver.swift
//  DreamingJournals
//
//  Created by moesmoesie on 13/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

func getBottomSaveArea() -> CGFloat{
    guard let root = UIApplication.shared.windows.first else {
        return 0
    }

    return root.safeAreaInsets.bottom
}

func getTopSaveArea() -> CGFloat{
    guard let root = UIApplication.shared.windows.first else {
        return 0
    }

    return root.safeAreaInsets.top
}

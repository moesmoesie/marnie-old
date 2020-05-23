//
//  Fonts.swift
//  DreamingJournals
//
//  Created by moesmoesie on 23/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

extension Font{
    static var primarySmall : Font = Font.caption
    static var secondarySmall : Font = Font.caption
    static var primaryRegular : Font = Font.body
    static var secondaryRegular : Font = Font.caption.bold()
    static var primaryLarge : Font = Font.headline
    static var secondaryLarge : Font = Font.largeTitle.bold()
}

extension UIFont{

    static var primaryRegular : UIFont = UIFont.preferredFont(forTextStyle: .body)
    static var secondaryRegular : UIFont = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor.withSymbolicTraits(.traitBold) ?? UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor, size: UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor.withSymbolicTraits(.traitBold)?.pointSize ?? UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor.pointSize)

    static var primaryLarge : UIFont = UIFont.preferredFont(forTextStyle: .headline)
    static var secondaryLarge : UIFont = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .largeTitle).fontDescriptor.withSymbolicTraits(.traitBold) ?? UIFont.preferredFont(forTextStyle: .largeTitle).fontDescriptor, size: UIFont.preferredFont(forTextStyle: .largeTitle).fontDescriptor.withSymbolicTraits(.traitBold)?.pointSize ?? UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor.pointSize)
    
    static var primarySmall : Font = Font.caption
    static var secondarySmall : UIFont = UIFont.preferredFont(forTextStyle: .caption1)
}

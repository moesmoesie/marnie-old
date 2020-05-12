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
    
    @Published var passiveDarkColor : Color = Color(red: 46 / 255.0, green: 49 / 255.0, blue: 56/225.0)
    @Published var passiveLightColor : Color = Color(red: 249 / 255.0, green: 249 / 255.0, blue: 249/225.0)
    
    
    @Published var primaryColor : Color = Color(red: 226 / 255.0, green: 157 / 255.0, blue: 29/225.0)
    @Published var secundaryColor : Color = Color(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0)
    @Published var tertiaryColor : Color = Color.red
    
    @Published var primaryUIColor : UIColor = UIColor(red: 226 / 255.0, green: 157 / 255.0, blue: 29/225.0, alpha: 1)
    @Published var secundaryUIColor : UIColor = UIColor(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0, alpha: 1)
    @Published var tertiaryUIColor : UIColor = UIColor.red
    
    @Published var primaryBackgroundColor : Color = Color(red: 22 / 255.0, green: 29 / 255.0, blue: 67/225.0)
    @Published var secundaryBackgroundColor : Color = Color(red: 31 / 255.0, green: 38 / 255.0, blue: 76/225.0)
    
    @Published var textTitleColor : Color = Color(red: 249 / 255.0, green: 249 / 255.0, blue: 249/225.0)
    @Published var textTitleUIColor : UIColor = UIColor(red: 249 / 255.0, green: 249 / 255.0, blue: 249/225.0, alpha: 1)
    
    @Published var textBodyColor : Color = Color(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0)
    @Published var textBodyUIColor : UIColor = UIColor(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0, alpha: 1)
    
    @Published var primaryRegularFont : Font = Font.body
    @Published var secundaryRegularFont : Font = Font.caption.bold()
    @Published var primaryLargeFont : Font = Font.headline
    @Published var secundaryLargeFont : Font = Font.largeTitle.bold()
    
    @Published var primaryRegularUIFont : UIFont = UIFont.preferredFont(forTextStyle: .body)
    @Published var secundaryRegularUIFont : UIFont = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor.withSymbolicTraits(.traitBold) ?? UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor, size: UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor.withSymbolicTraits(.traitBold)?.pointSize ?? UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor.pointSize)
    @Published var primaryLargeUIFont : UIFont = UIFont.preferredFont(forTextStyle: .headline)
    @Published var secundaryLargeUIFont : UIFont = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .largeTitle).fontDescriptor.withSymbolicTraits(.traitBold) ?? UIFont.preferredFont(forTextStyle: .largeTitle).fontDescriptor, size: UIFont.preferredFont(forTextStyle: .largeTitle).fontDescriptor.withSymbolicTraits(.traitBold)?.pointSize ?? UIFont.preferredFont(forTextStyle: .caption1).fontDescriptor.pointSize)
    
    @Published var primarySmallFont : Font = Font.caption
    @Published var primarySmallUIFont : UIFont = UIFont.preferredFont(forTextStyle: .caption1)
}

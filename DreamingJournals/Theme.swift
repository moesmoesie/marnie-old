//
//  Theme.swift
//  DreamBook
//
//  Created by moesmoesie on 05/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class Theme : ObservableObject {
    
    private var lightModePassiveDarkColor : Color = Color(red: 46 / 255.0, green: 49 / 255.0, blue: 56/225.0)
    private var lightModePassiveLightColor : Color = .black
    
    private var lightModePrimaryColor : Color = Color(red: 226 / 255.0, green: 157 / 255.0, blue: 29/225.0)
    private var lightModeSecundaryColor : Color = Color(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0)
    private var lightModeTertiaryColor : Color = Color.red
    
    private var lightModePrimaryUIColor : UIColor = UIColor(red: 226 / 255.0, green: 157 / 255.0, blue: 29/225.0, alpha: 1)
    private var lightModeSecundaryUIColor : UIColor = UIColor(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0, alpha: 1)
    private var lightModeTertiaryUIColor : UIColor = UIColor.red
    
    private var lightModePrimaryBackgroundColor : Color = Color(red: 252 / 255.0, green: 252 / 255.0, blue: 252/225.0)
    private var lightModeSecundaryBackgroundColor : Color = Color(red: 239 / 255.0, green: 239 / 255.0, blue: 239/225.0)
    
    private var lightModeTextTitleColor : Color = .black
    private var lightModeTextTitleUIColor : UIColor = .black
    
    private var lightModeTextBodyColor : Color = .black
    private var lightModeTextBodyUIColor : UIColor = .black
    
    //darkmode
    
    private var darkModePassiveDarkColor : Color = Color(red: 46 / 255.0, green: 49 / 255.0, blue: 56/225.0)
    private var darkModePassiveLightColor : Color = Color(red: 249 / 255.0, green: 249 / 255.0, blue: 249/225.0)
    
    private var darkModePrimaryColor : Color = Color(red: 226 / 255.0, green: 157 / 255.0, blue: 29/225.0)
    private var darkModeSecundaryColor : Color = Color(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0)
    private var darkModeTertiaryColor : Color = Color.red
    
    private var darkModePrimaryUIColor : UIColor = UIColor(red: 226 / 255.0, green: 157 / 255.0, blue: 29/225.0, alpha: 1)
    private var darkModeSecundaryUIColor : UIColor = UIColor(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0, alpha: 1)
    private var darkModeTertiaryUIColor : UIColor = UIColor.red
    
    private var darkModePrimaryBackgroundColor : Color = Color(red: 22 / 255.0, green: 29 / 255.0, blue: 67/225.0)
    private var darkModeSecundaryBackgroundColor : Color = Color(red: 31 / 255.0, green: 38 / 255.0, blue: 76/225.0)
    
    private var darkModeTextTitleColor : Color = Color(red: 249 / 255.0, green: 249 / 255.0, blue: 249/225.0)
    private var darkModeTextTitleUIColor : UIColor = UIColor(red: 249 / 255.0, green: 249 / 255.0, blue: 249/225.0, alpha: 1)
    
    private var darkModeTextBodyColor : Color = Color(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0)
    private var darkModeTextBodyUIColor : UIColor = UIColor(red: 145 / 255.0, green: 196 / 255.0, blue: 242/225.0, alpha: 1)
    
    
    // publishers
    
    @Published var darkMode : Bool = true
    
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
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        
        self.$darkMode.sink { (darkMode) in
            self.primaryBackgroundColor = darkMode ? self.darkModePrimaryColor : self.lightModePrimaryColor
            self.secundaryColor = darkMode ? self.darkModeSecundaryColor : self.lightModeSecundaryColor
            self.tertiaryColor = darkMode ? self.darkModeTertiaryColor : self.lightModeTertiaryColor
            
            self.primaryUIColor = darkMode ? self.darkModePrimaryUIColor : self.lightModePrimaryUIColor
            self.secundaryUIColor = darkMode ? self.darkModeSecundaryUIColor : self.lightModeSecundaryUIColor
            self.tertiaryUIColor =  darkMode ? self.darkModeTertiaryUIColor : self.lightModeTertiaryUIColor
            
            self.primaryBackgroundColor = darkMode ? self.darkModePrimaryBackgroundColor : self.lightModePrimaryBackgroundColor
            self.secundaryBackgroundColor = darkMode ? self.darkModeSecundaryBackgroundColor : self.lightModeSecundaryBackgroundColor
            
            self.textTitleColor = darkMode ? self.darkModeTextTitleColor : self.lightModeTextTitleColor
            self.textTitleUIColor = darkMode ? self.darkModeTextTitleUIColor : self.lightModeTextTitleUIColor
            
            self.textBodyColor = darkMode ? self.darkModeTextBodyColor : self.lightModeTextBodyColor
            self.textBodyUIColor = darkMode ? self.darkModeTextBodyUIColor : self.textBodyUIColor
            
            self.passiveDarkColor = darkMode ? self.darkModePassiveDarkColor : self.lightModePassiveDarkColor
            self.passiveLightColor = darkMode ? self.darkModePassiveLightColor : self.lightModePassiveLightColor
            
        }.store(in: &cancellableSet)
    }
}

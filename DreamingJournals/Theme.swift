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
    
    
    @Published var darkMode : Bool = true
    
    @Published var extraSmallPadding : CGFloat = 5
    @Published var smallPadding : CGFloat = 10
    @Published var mediumPadding : CGFloat = 20
    @Published var largePadding : CGFloat = 30
    
    @Published var primaryColor = Color(red: 219 / 255.0, green: 84 / 255.0, blue: 97 / 255.0)
    @Published var secondaryColor = Color(red: 237 / 255.0, green: 106 / 255.0, blue: 90 / 255.0)
    @Published var textColor = Color(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0)
    @Published var secondaryTextColor = Color(red: 157 / 255.0, green: 157 / 255.0, blue: 157 / 255.0)
    @Published var backgroundColor = Color(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0)
    @Published var secondaryBackgroundColor = Color(red: 20 / 255.0, green: 25 / 255.0, blue: 28 / 255.0)
    @Published var passiveColor = Color(red: 219 / 255.0, green: 84 / 255.0, blue: 97 / 255.0)

    @Published var primaryUIColor = UIColor(red: 219 / 255.0, green: 219 / 255.0, blue: 219 / 225.0, alpha: 1)
    @Published var secondaryUIColor = UIColor(red: 219 / 255.0, green: 219 / 255.0, blue: 219 / 225.0, alpha: 1)
    @Published var textUIColor = UIColor(red: 219 / 255.0, green: 219 / 255.0, blue: 219 / 225.0, alpha: 1)
    @Published var secondaryTextUIColor = UIColor(red: 219 / 255.0, green: 219 / 255.0, blue: 219 / 225.0, alpha: 1)
    @Published var tertiaryTextUIColor = UIColor(red: 219 / 255.0, green: 219 / 255.0, blue: 219 / 225.0, alpha: 1)
    @Published var backgroundUIColor = UIColor(red: 219 / 255.0, green: 219 / 255.0, blue: 219 / 225.0, alpha: 1)
    @Published var secondaryBackgroundUIColor = UIColor(red: 219 / 255.0, green: 219 / 255.0, blue: 219 / 225.0, alpha: 1)
    @Published var passiveUIColor = UIColor(red: 219 / 255.0, green: 84 / 255.0, blue: 97 / 255.0, alpha: 1)

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
            self.primaryColor = darkMode ? self.primaryDarkModeColor : self.primaryLightModeColor
            self.primaryUIColor = darkMode ? self.primaryDarkModeUIColor : self.primaryLightModeUIColor

            self.secondaryColor = darkMode ? self.secondaryDarkModeColor : self.secondaryLightModeColor
            self.secondaryUIColor = darkMode ? self.secondaryDarkModeUIColor : self.secondaryLightModeUIColor

            self.textColor = darkMode ? self.textDarkModeColor : self.textLightModeColor
            self.textUIColor = darkMode ? self.textDarkModeUIColor : self.textLightModeUIColor

            self.secondaryTextColor = darkMode ? self.secondaryTextDarkModeColor : self.secondaryTextLightModeColor
            self.secondaryTextUIColor = darkMode ? self.secondaryTextDarkModeUIColor : self.secondaryTextLightModeUIColor

            self.backgroundColor = darkMode ? self.backgroundDarkModeColor : self.backgroundLightModeColor
            self.backgroundUIColor = darkMode ? self.backgroundDarkModeUIColor : self.backgroundLightModeUIColor

            self.secondaryBackgroundColor = darkMode ? self.secondaryBackgroundDarkModeColor : self.secondaryBackgroundLightModeColor
            self.secondaryBackgroundUIColor = darkMode ? self.secondaryBackgroundDarkModeUIColor : self.secondaryBackgroundLightModeUIColor
            
            self.passiveColor = darkMode ? self.passiveColorDarkModeColor : self.passiveColorLightModeColor
            self.passiveUIColor = darkMode ? self.passiveColorDarkModeUIColor : self.passiveColorLightModeUIColor

        }.store(in: &cancellableSet)
    }
    
    
    
    //MARK: - PYTHON GENERATED
    private var primaryDarkModeColor = Color(red: 219 / 255.0, green: 84 / 255.0, blue: 97 / 255.0)
    private var primaryDarkModeUIColor = UIColor(red: 219 / 255.0, green: 84 / 255.0, blue: 97 / 255.0, alpha: 1)
    private var primaryLightModeColor = Color(red: 219 / 255.0, green: 84 / 255.0, blue: 97 / 255.0)
    private var primaryLightModeUIColor = UIColor(red: 219 / 255.0, green: 84 / 255.0, blue: 97 / 255.0, alpha: 1)
    private var secondaryDarkModeColor = Color(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0)
    private var secondaryDarkModeUIColor = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1)
    private var secondaryLightModeColor = Color(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0)
    private var secondaryLightModeUIColor = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1)
    private var textDarkModeColor = Color(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0)
    private var textDarkModeUIColor = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1)
    private var textLightModeColor = Color(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0)
    private var textLightModeUIColor = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1)
    private var secondaryTextDarkModeColor = Color(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0)
    private var secondaryTextDarkModeUIColor = UIColor(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0, alpha: 1)
    private var secondaryTextLightModeColor = Color(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0)
    private var secondaryTextLightModeUIColor = UIColor(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0, alpha: 1)
    private var backgroundDarkModeColor = Color(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0)
    private var backgroundDarkModeUIColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1)
    private var backgroundLightModeColor = Color(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0)
    private var backgroundLightModeUIColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1)
    private var secondaryBackgroundDarkModeColor = Color(red: 20 / 255.0, green: 25 / 255.0, blue: 28 / 255.0)
    private var secondaryBackgroundDarkModeUIColor = UIColor(red: 20 / 255.0, green: 25 / 255.0, blue: 28 / 255.0, alpha: 1)
    private var secondaryBackgroundLightModeColor = Color(red: 20 / 255.0, green: 25 / 255.0, blue: 28 / 255.0)
    private var secondaryBackgroundLightModeUIColor = UIColor(red: 20 / 255.0, green: 25 / 255.0, blue: 28 / 255.0, alpha: 1)
    private var passiveColorDarkModeColor = Color(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0)
    private var passiveColorDarkModeUIColor = UIColor(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0, alpha: 1)
    private var passiveColorLightModeColor = Color(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0)
    private var passiveColorLightModeUIColor = UIColor(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0, alpha: 1)
}

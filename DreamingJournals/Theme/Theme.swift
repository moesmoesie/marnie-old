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
    private var cancellableSet: Set<AnyCancellable> = []
    
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
    
    @Published var extraSmallPadding : CGFloat = 5
    @Published var smallPadding : CGFloat = 10
    @Published var mediumPadding : CGFloat = 20
    @Published var largePadding : CGFloat = 30
    
    //MARK: - PYTHON GENERATED
private var primaryAccentDarkModeUIColor = UIColor(red: 252 / 255.0, green: 101 / 255.0, blue: 125 / 255.0, alpha: 1)
private var primaryAccentLightModeUIColor = UIColor(red: 252 / 255.0, green: 101 / 255.0, blue: 125 / 255.0, alpha: 1)
private var secondaryAccentDarkModeUIColor = UIColor(red: 237 / 255.0, green: 238 / 255.0, blue: 242 / 255.0, alpha: 1)
private var secondaryAccentLightModeUIColor = UIColor(red: 237 / 255.0, green: 238 / 255.0, blue: 242 / 255.0, alpha: 1)
private var primaryBackgroundDarkModeUIColor = UIColor(red: 2 / 255.0, green: 17 / 255.0, blue: 58 / 255.0, alpha: 1)
private var primaryBackgroundLightModeUIColor = UIColor(red: 2 / 255.0, green: 17 / 255.0, blue: 58 / 255.0, alpha: 1)
private var secondaryBackgroundDarkModeUIColor = UIColor(red: 4 / 255.0, green: 22 / 255.0, blue: 66 / 255.0, alpha: 1)
private var secondaryBackgroundLightModeUIColor = UIColor(red: 4 / 255.0, green: 22 / 255.0, blue: 66 / 255.0, alpha: 1)
private var negativeActionDarkModeUIColor = UIColor(red: 252 / 255.0, green: 101 / 255.0, blue: 125 / 255.0, alpha: 1)
private var negativeActionLightModeUIColor = UIColor(red: 252 / 255.0, green: 101 / 255.0, blue: 125 / 255.0, alpha: 1)
private var positiveActionDarkModeUIColor = UIColor(red: 237 / 255.0, green: 238 / 255.0, blue: 242 / 255.0, alpha: 1)
private var positiveActionLightModeUIColor = UIColor(red: 237 / 255.0, green: 238 / 255.0, blue: 242 / 255.0, alpha: 1)
private var unSelectedDarkModeUIColor = UIColor(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0, alpha: 1)
private var unSelectedLightModeUIColor = UIColor(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0, alpha: 1)
private var selectedDarkModeUIColor = UIColor(red: 237 / 255.0, green: 238 / 255.0, blue: 242 / 255.0, alpha: 1)
private var selectedLightModeUIColor = UIColor(red: 237 / 255.0, green: 238 / 255.0, blue: 242 / 255.0, alpha: 1)
private var unSelectedAccentDarkModeUIColor = UIColor(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0, alpha: 1)
private var unSelectedAccentLightModeUIColor = UIColor(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0, alpha: 1)
private var selectedAccentDarkModeUIColor = UIColor(red: 252 / 255.0, green: 101 / 255.0, blue: 125 / 255.0, alpha: 1)
private var selectedAccentLightModeUIColor = UIColor(red: 252 / 255.0, green: 101 / 255.0, blue: 125 / 255.0, alpha: 1)
private var primaryTextDarkModeUIColor = UIColor(red: 237 / 255.0, green: 238 / 255.0, blue: 242 / 255.0, alpha: 1)
private var primaryTextLightModeUIColor = UIColor(red: 237 / 255.0, green: 238 / 255.0, blue: 242 / 255.0, alpha: 1)
private var secondaryTextDarkModeUIColor = UIColor(red: 157 / 255.0, green: 157 / 255.0, blue: 157 / 255.0, alpha: 1)
private var secondaryTextLightModeUIColor = UIColor(red: 157 / 255.0, green: 157 / 255.0, blue: 157 / 255.0, alpha: 1)
private var primaryAccentTextDarkModeUIColor = UIColor(red: 252 / 255.0, green: 101 / 255.0, blue: 125 / 255.0, alpha: 1)
private var primaryAccentTextLightModeUIColor = UIColor(red: 252 / 255.0, green: 101 / 255.0, blue: 125 / 255.0, alpha: 1)
private var placeHolderTextDarkModeUIColor = UIColor(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0, alpha: 1)
private var placeHolderTextLightModeUIColor = UIColor(red: 93 / 255.0, green: 93 / 255.0, blue: 93 / 255.0, alpha: 1)

@Published var primaryAccentColor : Color = .clear 
@Published var secondaryAccentColor : Color = .clear 
@Published var primaryBackgroundColor : Color = .clear 
@Published var secondaryBackgroundColor : Color = .clear 
@Published var negativeActionColor : Color = .clear 
@Published var positiveActionColor : Color = .clear 
@Published var unSelectedColor : Color = .clear 
@Published var selectedColor : Color = .clear 
@Published var unSelectedAccentColor : Color = .clear 
@Published var selectedAccentColor : Color = .clear 
@Published var primaryTextColor : Color = .clear 
@Published var secondaryTextColor : Color = .clear 
@Published var primaryAccentTextColor : Color = .clear 
@Published var placeHolderTextColor : Color = .clear 

@Published var primaryAccentUIColor : UIColor = .clear 
@Published var secondaryAccentUIColor : UIColor = .clear 
@Published var primaryBackgroundUIColor : UIColor = .clear 
@Published var secondaryBackgroundUIColor : UIColor = .clear 
@Published var negativeActionUIColor : UIColor = .clear 
@Published var positiveActionUIColor : UIColor = .clear 
@Published var unSelectedUIColor : UIColor = .clear 
@Published var selectedUIColor : UIColor = .clear 
@Published var unSelectedAccentUIColor : UIColor = .clear 
@Published var selectedAccentUIColor : UIColor = .clear 
@Published var primaryTextUIColor : UIColor = .clear 
@Published var secondaryTextUIColor : UIColor = .clear 
@Published var primaryAccentTextUIColor : UIColor = .clear 
@Published var placeHolderTextUIColor : UIColor = .clear 

init() { 
       self.$darkMode.sink { (darkMode) in
          self.primaryAccentUIColor = darkMode ? self.primaryAccentDarkModeUIColor : self.primaryAccentLightModeUIColor 
          self.primaryAccentColor = Color(self.primaryAccentUIColor) 
          self.secondaryAccentUIColor = darkMode ? self.secondaryAccentDarkModeUIColor : self.secondaryAccentLightModeUIColor 
          self.secondaryAccentColor = Color(self.secondaryAccentUIColor) 
          self.primaryBackgroundUIColor = darkMode ? self.primaryBackgroundDarkModeUIColor : self.primaryBackgroundLightModeUIColor 
          self.primaryBackgroundColor = Color(self.primaryBackgroundUIColor) 
          self.secondaryBackgroundUIColor = darkMode ? self.secondaryBackgroundDarkModeUIColor : self.secondaryBackgroundLightModeUIColor 
          self.secondaryBackgroundColor = Color(self.secondaryBackgroundUIColor) 
          self.negativeActionUIColor = darkMode ? self.negativeActionDarkModeUIColor : self.negativeActionLightModeUIColor 
          self.negativeActionColor = Color(self.negativeActionUIColor) 
          self.positiveActionUIColor = darkMode ? self.positiveActionDarkModeUIColor : self.positiveActionLightModeUIColor 
          self.positiveActionColor = Color(self.positiveActionUIColor) 
          self.unSelectedUIColor = darkMode ? self.unSelectedDarkModeUIColor : self.unSelectedLightModeUIColor 
          self.unSelectedColor = Color(self.unSelectedUIColor) 
          self.selectedUIColor = darkMode ? self.selectedDarkModeUIColor : self.selectedLightModeUIColor 
          self.selectedColor = Color(self.selectedUIColor) 
          self.unSelectedAccentUIColor = darkMode ? self.unSelectedAccentDarkModeUIColor : self.unSelectedAccentLightModeUIColor 
          self.unSelectedAccentColor = Color(self.unSelectedAccentUIColor) 
          self.selectedAccentUIColor = darkMode ? self.selectedAccentDarkModeUIColor : self.selectedAccentLightModeUIColor 
          self.selectedAccentColor = Color(self.selectedAccentUIColor) 
          self.primaryTextUIColor = darkMode ? self.primaryTextDarkModeUIColor : self.primaryTextLightModeUIColor 
          self.primaryTextColor = Color(self.primaryTextUIColor) 
          self.secondaryTextUIColor = darkMode ? self.secondaryTextDarkModeUIColor : self.secondaryTextLightModeUIColor 
          self.secondaryTextColor = Color(self.secondaryTextUIColor) 
          self.primaryAccentTextUIColor = darkMode ? self.primaryAccentTextDarkModeUIColor : self.primaryAccentTextLightModeUIColor 
          self.primaryAccentTextColor = Color(self.primaryAccentTextUIColor) 
          self.placeHolderTextUIColor = darkMode ? self.placeHolderTextDarkModeUIColor : self.placeHolderTextLightModeUIColor 
          self.placeHolderTextColor = Color(self.placeHolderTextUIColor) 
       }.store(in: &cancellableSet)
   }}

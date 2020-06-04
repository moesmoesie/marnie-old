//
//  CustomIconButton.swift
//  DreamingJournals
//
//  Created by moesmoesie on 25/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct CustomIconButton: View {
    let icon : Image
    let isActive : Bool
    let action : () -> ()
    let iconSize : IconSize
    
    init(icon : Image,iconSize : IconSize, isActive : Bool = false, action: @escaping () -> () = {}) {
        self.icon = icon
        self.isActive = isActive
        self.action = action
        self.iconSize = iconSize
    }
    
    var body: some View {
        return icon
            .imageScale(iconSize.getIconSize())
            .foregroundColor(isActive ? Color.main1 : Color.main2 )
            .frame(width: iconSize.getFrameSize(), height: iconSize.getFrameSize())
            .background(isActive ? Color.accent1 : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 12.5))
            .onTapGesture{
                self.action()
        }
    }
}


struct CustomPassiveIconButton: View {
    let icon : Image
    let action : () -> ()
    let iconSize : IconSize
    
    init(icon : Image,iconSize : IconSize, isActive : Bool = false, action: @escaping () -> () = {}) {
        self.icon = icon
        self.action = action
        self.iconSize = iconSize
    }
    
    var body: some View {
        return icon
            .imageScale(iconSize.getIconSize())
            .foregroundColor(Color.main2 )
            .frame(width: iconSize.getFrameSize(), height: iconSize.getFrameSize())
            .background(Color.background2)
            .clipShape(RoundedRectangle(cornerRadius: 12.5))
            .onTapGesture{
                self.action()
        }
    }
}

struct CustomIconButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            CustomIconButton(icon: Image.lucidIcon,iconSize: .small, isActive: false){
                print("Hello World")
            }
            
            CustomIconButton(icon: Image.bookmarkIcon,iconSize: .medium, isActive: false){
                print("Hello World")
            }
            
            CustomIconButton(icon: Image.nightmareIcon,iconSize: .large, isActive: false){
                print("Hello World")
            }
        }
    }
}



enum IconSize : CGFloat{
    case small
    case medium
    case large

    
    func getFrameSize() -> CGFloat{
        
        switch self {
            case .small:
                return .medium * 1.8
            case .medium:
                return .medium * 2.2
            case .large:
                return .medium * 2.8
        }
    }
    
    func getCornerRadius() -> CGFloat{
        return getFrameSize() / 5
    }
    
    
    func getIconSize() -> Image.Scale{
        switch self {
            case .small:
                return .small
            case .medium:
                return .medium
            case .large:
                return .large
        }
    }
}

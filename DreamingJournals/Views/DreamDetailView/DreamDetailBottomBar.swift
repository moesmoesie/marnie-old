//
//  DreamDetailBottomBar.swift
//  DreamingJournals
//
//  Created by moesmoesie on 25/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamDetailBottomBar: View {
    var body: some View {
        ZStack(alignment: .top){
            Rectangle()
                .foregroundColor(.background2)
                .frame(height: 1).opacity(0.3)
            HStack{
                Group{
                    Spacer()
                    BottomBarIcon(iconName: "heart")
                }
                
                Group{
                    Spacer()
                    BottomBarIcon(iconName: "eye")
                }
                
                Group{
                    Spacer()
                    BottomBarIcon(iconName: "tropicalstorm")
                }
                
                Group{
                    Spacer()
                    BottomBarIcon(iconName: "tag")
                }
                
                Group{
                    Spacer()
                    BottomBarIcon(iconName: "trash")
                    Spacer()
                }
            }.padding(.top, .medium)
            .padding(.bottom, getBottomSaveArea() > 0 ? .small : .medium)
        }
        .padding(.bottom, getBottomSaveArea())
        .background(Color.background1)
    }
}

struct BottomBarIcon: View{
    @State var isActive = false
    let iconName : String
    
    init(iconName : String) {
        self.iconName = iconName
    }
    
    var body: some View{
        Image(systemName: iconName)
            .imageScale(.medium)
            .foregroundColor(isActive ? .accent1 : .main1 )
            .shadow(color: isActive ? Color.accent1.opacity(0.3) : .clear, radius: 10, x: 0, y: 0)
            .frame(width: .extraLarge, height: .extraLarge)
            .background(Color.background3)
            .cornerRadius(10)
            .primaryShadow()
    }
}

struct DreamDetailBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        DreamDetailBottomBar()
    }
}

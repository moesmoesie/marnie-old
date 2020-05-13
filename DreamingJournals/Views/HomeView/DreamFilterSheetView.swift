//
//  DreamFilterSheetView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 13/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamFilterSheetView: View {
    @EnvironmentObject var theme : Theme
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack(alignment:.top){
            theme.primaryBackgroundColor.edgesIgnoringSafeArea(.all)
            VStack{
                HStack(alignment:.center, spacing: theme.mediumPadding){
                    Text("Filters").font(theme.secundaryLargeFont).foregroundColor(theme.textTitleColor)
                    Spacer()
                    Button(action:{
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width : theme.largePadding, height: theme.largePadding)
                            .foregroundColor(theme.passiveLightColor)
                    }
                }.padding(.horizontal, theme.mediumPadding)
                    .padding(.top, theme.mediumPadding)
                ZStack(alignment: .center){
                    Text("No Active Filters")
                        .foregroundColor(theme.textTitleColor)
                        .opacity(0.5)
                        .offset(x: 0, y: -theme.smallPadding)
                }
                .padding(.horizontal, theme.mediumPadding)
                .frame(minHeight : 200)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(theme.passiveDarkColor)
                HStack{Text("Available Filters")
                    .font(theme.primaryLargeFont)
                    .foregroundColor(theme.textTitleColor)
                    .padding()
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct DreamFilterSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DreamFilterSheetView()
    }
}

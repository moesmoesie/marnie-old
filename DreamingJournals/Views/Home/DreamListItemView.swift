//
//  DreamListItem.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamListItemView : View {
    @State var showDetail = false
    let dream : Dream
    
    func calculateCardSize(text: String, hasDetails : Bool, hasTags : Bool) -> CGFloat{
        var size : CGFloat = .cardSize * 0.9
        if text.count < 50{
            size *= 0.6
        }
        
        if !hasTags{
            size -= .large
        }
        
        if !hasDetails{
            size *= 0.8
        }
        
        return size
    }
    
    var body: some View{
        VStack(alignment : .leading, spacing: 0){
            naviagationLink
            
            dateView
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, .extraSmall)

            
            titleView
            
            if !dream.wrappedTags.isEmpty{
                tags
                    .padding(.vertical, .extraSmall)
            }
        
            textView
            
            Spacer()

            details
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal,.medium)
        .padding(.bottom, .medium)
        .padding(.top,.small)
        .background(Color.background1)
        .cornerRadius(30)
        .primaryShadow()
        .onTapGesture {
            self.showDetail = true
        }
    }
    
    // MARK: - HELPER VIEWS
    
    private var naviagationLink : some View{
        NavigationLink(destination: LazyView(DreamDetailView(dream: self.dream)), isActive: $showDetail){
            EmptyView()
        }.hidden()
    }
    
    private var details : some View{
        HStack(spacing: .medium){
            if dream.isBookmarked{
                CustomIconButton(iconName: "heart", iconSize: .medium)
            }
            
            if dream.isLucid{
                CustomIconButton(iconName: "eye", iconSize: .medium)
            }
            
            if dream.isNightmare{
                CustomIconButton(iconName: "tropicalstorm", iconSize: .medium)
            }
        }
    }
    
    private var tags : some View{
        HStack{
            ForEach(self.dream.wrappedTags.prefix(2), id: \.self ){ tag in
                TagView(tag: TagViewModel(tag: tag))
            }
        }
    }
    
    private var seperator : some View{
        Rectangle()
            .foregroundColor(Color.main1)
            .frame(maxWidth :.infinity)
            .frame(height: 1)
            .opacity(0.1)
    }
    
    private var titleView: some View{
        Text(dream.wrappedTitle)
            .font(.primaryLarge)
            .foregroundColor(.main1)
            .lineLimit(1)
    }
    
    private var textView : some View {
        let textToShow = dream.wrappedText.replacingOccurrences(of: "\n", with: "")
        return Text(textToShow)
            .foregroundColor(.main1)
            .lineSpacing(.extraSmall)
            .frame(maxHeight: 100)
    }
    
    private var dateView : some View{
        Text(dream.wrapperDateString)
            .font(.primarySmall)
            .foregroundColor(.main2)
    }
}

//
//  DreamListItem.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamListItemView : View {
    @EnvironmentObject var filterObserver : FilterObserver
    let dreamListItem : DreamListItemModel
    @State var showDetail = false
    
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
                .padding(.bottom, .small)

        
            if !dreamListItem.dream.tags.isEmpty{
                tags
                    .padding(.bottom, .small)
            }

            textView
            
            Spacer()

            if !dreamListItem.details.isEmpty{
                seperator
                    .padding(.bottom,.small)
            }
            
            details
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: calculateCardSize(text: dreamListItem.dream.text, hasDetails: !dreamListItem.details.isEmpty, hasTags: !dreamListItem.dream.tags.isEmpty), alignment: .top)
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
        NavigationLink(destination: DreamDetailView(dream: dreamListItem.dream), isActive: $showDetail){
            EmptyView()
        }.hidden()
    }
    
    private var details : some View{
        HStack(spacing: .medium){
            ForEach(dreamListItem.details){(detail : DreamListItemModel.Detail) in
                CustomIconButton(
                    iconName: detail.icon,
                    iconSize: .small,
                    isActive: self.filterObserver.isFilterTypeActive(filter: FilterViewModel(filter: detail.filter)))
            }
        }
    }
    
    private var tags : some View{
        HStack{
            ForEach(self.dreamListItem.dream.tags.prefix(2)){ tag in
                TagView(tag: tag)
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
        Text(dreamListItem.dream.title)
            .font(.primaryLarge)
            .foregroundColor(.main1)
            .lineLimit(1)
    }
    
    private var textView : some View {
        let textToShow = dreamListItem.dream.text.replacingOccurrences(of: "\n", with: "")
        return Text(textToShow)
            .foregroundColor(.main1)
            .lineSpacing(.extraSmall)
    }
    
    private var dateView : some View{
        Text(dreamListItem.dream.wrapperDateString)
            .font(.primarySmall)
            .foregroundColor(.main2)
    }
}

struct DreamListItem_Previews: PreviewProvider {
    static var previews: some View {
        return ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            VStack(spacing: .medium){
                DreamListItemView(dreamListItem: DreamListItemModel(sampleData[0]))
                    .padding(.horizontal, .medium)
                
                DreamListItemView(dreamListItem: DreamListItemModel(sampleData[2]))
                    .padding(.horizontal, .medium)
            }
        }
    }
}

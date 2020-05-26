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
    
    var body: some View{
        VStack(alignment : .leading, spacing: 0){
            naviagationLink
            
            titleView
            
            dateView
                .padding(.bottom, .extraSmall)
            
            tags
            Spacer(minLength: .extraSmall)
            
            textView
            
            Spacer(minLength: .extraSmall)

            if !dreamListItem.details.isEmpty{
                seperator
                    .padding(.bottom,.small)
            }
            
            details
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: dreamListItem.details.isEmpty ? .cardSize * 0.8 : .cardSize, alignment: .top)
        .padding(.medium)
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
        CollectionView(data: dreamListItem.dream.tags, maxRows: 1) { tag in
            TagView(tag: tag)
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
            .font(Font.primaryLarge)
            .foregroundColor(.main1)
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

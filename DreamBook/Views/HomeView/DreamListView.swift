//
//  DreamListView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct DreamListView: View {
    @FetchRequest(entity: Dream.entity(), sortDescriptors: []) var dreams : FetchedResults<Dream>
    @EnvironmentObject var theme : Theme
    var body: some View {
        List{
            ForEach(dreams, id: \.self){ (dream: Dream) in
                VStack(alignment: .leading, spacing: 0){
                    NavigationLink(destination: DreamDetailView(dream: dream)){EmptyView()}.hidden()
                    HStack{
                        Text(dream.wrapperDateString).font(.caption).foregroundColor(self.theme.primaryColor).bold()
                        Spacer()
                        if dream.isBookmarked{
                            Image(systemName: "heart.fill").foregroundColor(self.theme.primaryColor)                        }
                    }
                    .padding(.bottom,3)
                    Text(dream.wrappedTitle).bold().font(.headline).foregroundColor(self.theme.textTitleColor)
                        .padding(.bottom,3)
                    
                    TagCollectionView(tags: .constant(dream.wrappedTags)).padding(.vertical,3)
                    
                    Text(dream.wrappedText.replacingOccurrences(of: "\n", with: "")).lineLimit(6).foregroundColor(self.theme.textBodyColor)
                }.listRowInsets(EdgeInsets())
                    .padding(self.theme.mediumPadding)
                    .background(self.theme.secundaryBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: self.theme.mediumPadding))
                    .padding(.horizontal, self.theme.largePadding)
                    .padding(.bottom, self.theme.largePadding)
            }
        }
        .onAppear{
            UITableView.appearance().backgroundColor = .clear
            UITableView.appearance().separatorStyle = .none
            UITableViewCell.appearance().backgroundColor = .clear
            UITableViewCell.appearance().selectionStyle = .none
        }
    }
}

struct DreamListView_Previews: PreviewProvider {
    static var previews: some View {
        DreamListView()
    }
}

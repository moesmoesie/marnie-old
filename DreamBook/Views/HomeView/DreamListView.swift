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
    
    var body: some View {
        List{
            ForEach(dreams, id: \.self){ (dream: Dream) in
                VStack(alignment: .leading){
                    NavigationLink(destination: DreamDetailView(dream: dream)){EmptyView()}
                    HStack(alignment: VerticalAlignment.firstTextBaseline){
                        Text(dream.dateString).font(.caption)
                        Spacer()
                        if dream.isBookmarked{
                            Image(systemName: "heart")
                        }
                    }
                    Text(dream.title ?? "No title").font(.headline)
                    Text(dream.text ?? "").lineLimit(5)
                }
            }
        }
    }
}

struct DreamListView_Previews: PreviewProvider {
    static var previews: some View {
        DreamListView()
    }
}

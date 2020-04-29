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
            ForEach(dreams, id: \.self){ dream in
                NavigationLink(
                    destination: DreamDetailView(dream: dream)
                ){
                    VStack{
                        HStack{
                            Text(dream.title ?? "No title")
                            if dream.isBookmarked{
                                Spacer()
                                Image(systemName: "heart")
                            }
                        }
                        Text(dream.dateString)
                    }
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

//
//  DreamListView.swift
//  DreamBook
//
//  Created by moesmoesie on 29/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct DreamList : View {
    @EnvironmentObject var fetchObserver : FetchObserver
    var dreams: FetchedResults<Dream>
    
    var body: some View{
        return List{
            ListHeader()
                .listRowInsets(EdgeInsets())
                .padding(.bottom, .medium)
            ForEach(dreams, id : \.self){ (dream : Dream) in
                DreamListItemView(dream: dream)
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, .medium / 2)
                    .padding(.horizontal, .medium)
                    .onAppear{
                        if let lastDream = self.fetchObserver.lastDream{
                            if dream == lastDream{
                                DispatchQueue.main.async {
                                    self.fetchObserver.incrementLimit()
                                }
                            }
                        }
                }
            }
            Spacer(minLength: .navigationBarHeight * 1.5)
            }
        .edgesIgnoringSafeArea(.all)
    }
}

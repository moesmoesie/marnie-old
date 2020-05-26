//
//  CollectionView.swift
//  DreamingJournals
//
//  Created by moesmoesie on 15/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

//
//  TagCollectionView.swift
//  DreamBook
//
//  Created by moesmoesie on 01/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import Combine

struct CollectionView<Data: Identifiable,Content: View>: View {
    let content : (Data) -> Content
    var data : [Data]
    @State var height : CGFloat = 0
    
    init(data: [Data], content: @escaping (Data) -> Content) {
        self.data =  data
        self.content = content
    }
    
    var body: some View{
        var currentHeight : CGFloat = .zero
        var currentWidth : CGFloat = .zero
        var currentFrameHeight : CGFloat = .zero
        
        return GeometryReader{ geo in
            return ZStack(alignment: .topLeading){
                Color.clear
                ForEach(self.data){ element in
                    self.content(element)
                        .padding([.trailing], .small)
                        .alignmentGuide(.leading) { (d) -> CGFloat in
                            if element.id == self.data.first!.id{
                                currentHeight = .zero
                                currentWidth = .zero
                                currentFrameHeight = d.height
                            }
                            
                            var position = currentWidth
                            var endPosition = position - d.width
    
                            if -endPosition > geo.size.width{
                                currentWidth = .zero
                                currentHeight -= (d.height + .small)
                                position = .zero
                                endPosition = position - d.width
                                currentFrameHeight += (d.height + .small)
                            }
                            
                            currentWidth = endPosition
                            return position
                    }
                    .alignmentGuide(.top) { (d) -> CGFloat in
                        return currentHeight
                    }
                }
            }
        }.frame(height : self.height)
        .onAppear{
            DispatchQueue.main.async {
                self.height = currentFrameHeight
            }
        }
    }
}

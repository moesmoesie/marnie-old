//
//  TagCollectionView.swift
//  DreamBook
//
//  Created by moesmoesie on 01/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI

struct TagCollectionView: View {
    @State var height : CGFloat = 0
    @EnvironmentObject var theme : Theme
    @ObservedObject var dream : DreamViewModel
    
    var body: some View {
        var currentHeight : CGFloat = .zero
        var currentWidth : CGFloat = .zero
        var currentFrameHeight : CGFloat = .zero
        
        if dream.tags.isEmpty{
            DispatchQueue.main.async {
                self.height = 0
            }
        }
        
        return GeometryReader{ geo in
            ZStack(alignment: .topLeading){
                Color.clear
                ForEach(self.dream.tags){ tag in
                    TagView(tag: tag)
                        .padding([.trailing], self.theme.smallPadding)
                        .alignmentGuide(.leading) { (d) -> CGFloat in
                            if tag == self.dream.tags.first!{
                                currentHeight = .zero
                                currentWidth = .zero
                                currentFrameHeight = d.height
                            }
                            
                            var position = currentWidth
                            var endPosition = position - d.width
                            
                            if -endPosition > geo.size.width{
                                currentWidth = .zero
                                currentHeight -= (d.height + self.theme.smallPadding)
                                position = .zero
                                endPosition = position - d.width
                                currentFrameHeight += (d.height + self.theme.smallPadding)
                            }
                            
                            currentWidth = endPosition
                            return position
                    }
                    .alignmentGuide(.top) { (d) -> CGFloat in
                        if tag == self.dream.tags.last!{
                            DispatchQueue.main.async {
                                self.height = currentFrameHeight
                            }
                        }
                        return currentHeight
                    }
                    .onTapGesture {
                        let index = self.dream.tags.firstIndex(of: tag)!
                        self.dream.tags.remove(at: index)
                    }
                }
            }
        }.frame(height : self.height)
    }
}

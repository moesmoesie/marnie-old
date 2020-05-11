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
    @State var itemCount : Int?
    let maxRows : Int
    @EnvironmentObject var theme : Theme
    @ObservedObject var dream : DreamViewModel
    let isEditable : Bool
    
    init(_ dream : DreamViewModel, isEditable: Bool = false, maxRows : Int = .max) {
        self.dream = dream
        self.isEditable = isEditable
        self.maxRows = maxRows
    }
    
    var body: some View {
        var currentHeight : CGFloat = .zero
        var currentWidth : CGFloat = .zero
        var currentFrameHeight : CGFloat = .zero
        var currentItemCount : Int = 0
        var currentRowCount : Int = 0
        
        if dream.tags.isEmpty{
            DispatchQueue.main.async {
                self.height = 0
            }
        }
        
        return GeometryReader{ geo in
            ZStack(alignment: .topLeading){
                Color.clear
                ForEach(self.dream.tags.prefix(self.itemCount ?? self.dream.tags.count)){ tag in
                    TagView(tag: tag)
                        .padding([.trailing], self.theme.smallPadding)
                        .alignmentGuide(.leading) { (d) -> CGFloat in
                            if tag == self.dream.tags.first!{
                                currentHeight = .zero
                                currentWidth = .zero
                                currentFrameHeight = d.height
                                currentRowCount = 1
                                currentItemCount = 0
                            }
                            
                            var position = currentWidth
                            var endPosition = position - d.width
                            
                            if -endPosition > geo.size.width{
                                currentWidth = .zero
                                currentHeight -= (d.height + self.theme.smallPadding)
                                position = .zero
                                endPosition = position - d.width
                                currentRowCount += 1
                                if currentRowCount <= self.maxRows{
                                    currentFrameHeight += (d.height + self.theme.smallPadding)
                                }
                            }
                            
                            if currentRowCount <= self.maxRows{
                                currentItemCount += 1
                            }
                            
                            currentWidth = endPosition
                            return position
                    }
                    .alignmentGuide(.top) { (d) -> CGFloat in
                        if tag == self.dream.tags.last!{
                            DispatchQueue.main.async {
                                self.height = currentFrameHeight
                                self.itemCount = currentItemCount
                            }
                        }
                        return currentHeight
                    }
                    .onTapGesture {
                        if self.isEditable{
                            let index = self.dream.tags.firstIndex(of: tag)!
                            self.dream.tags.remove(at: index)
                        }
                    }
                }
            }
        }.frame(height : self.height)
            .disabled(!isEditable)
        }
}

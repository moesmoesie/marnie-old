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
    @State var itemCount : Int?
    @State var prevDataCount: Int?
    @EnvironmentObject var theme : Theme
    let maxRows : Int
    let animate : Bool
    
    init(data: [Data],maxRows : Int = .max, animate : Bool = false , content: @escaping (Data) -> Content) {
        self.data =  data
        self.content = content
        self.maxRows = maxRows
        self.animate = animate
    }
    
    var body: some View{
        var currentHeight : CGFloat = .zero
        var currentWidth : CGFloat = .zero
        var currentFrameHeight : CGFloat = .zero
        var currentItemCount : Int = 0
        var currentRowCount : Int = 0
        
        if let dataCount = prevDataCount{
            if dataCount != data.count{
                DispatchQueue.main.async {
                    self.itemCount = nil
                }
            }
        }
        
        if data.isEmpty{
            DispatchQueue.main.async {
                self.height = 0
            }
        }
        
        return GeometryReader{ geo in
            return ZStack(alignment: .topLeading){
                Color.clear
                ForEach(self.data.prefix(self.itemCount ?? self.data.count)){ element in
                    if currentRowCount <= self.maxRows{
                        self.content(element)
                            .padding([.trailing], self.theme.smallPadding)
                            .alignmentGuide(.leading) { (d) -> CGFloat in
                                if element.id == self.data.first!.id{
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
                            if element.id == self.data.last!.id{
                                DispatchQueue.main.async {
                                    self.height = currentFrameHeight
                                    if self.itemCount == nil{
                                        self.prevDataCount = self.data.count
                                    }
                                    self.itemCount = currentItemCount
                                }
                            }
                            return currentHeight
                        }
                    }
                }
            }
        }.frame(height : self.height)
        .animation(animate ? .easeInOut : nil)
    }
}

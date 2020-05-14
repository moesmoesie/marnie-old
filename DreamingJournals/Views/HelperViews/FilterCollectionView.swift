//
//  TagCollectionView.swift
//  DreamBook
//
//  Created by moesmoesie on 01/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import Combine
struct FilterCollectionView: View {
    @State var height : CGFloat = 0
    @State var itemCount : Int?
    @State var cancellables = Set<AnyCancellable>()
    @EnvironmentObject var theme : Theme
    @Binding var tags : [TagViewModel]
    let action : (TagViewModel) -> ()
    init(_ tags : Binding<[TagViewModel]>,action : @escaping (TagViewModel) -> ()) {
        self._tags = tags
        self.action = action
    }
    
    var body: some View {
        var currentHeight : CGFloat = .zero
        var currentWidth : CGFloat = .zero
        var currentFrameHeight : CGFloat = .zero
        
        if tags.isEmpty{
            DispatchQueue.main.async {
                self.height = 0
            }
        }
        
        return GeometryReader{ geo in
            ZStack(alignment: .topLeading){
                Color.clear
                ForEach(self.tags){ tag in
                    TagView(tag: tag)
                        .padding([.trailing], self.theme.smallPadding)
                        .alignmentGuide(.leading) { (d) -> CGFloat in
                            if tag == self.tags.first!{
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
                        if tag == self.tags.last!{
                            DispatchQueue.main.async {
                                self.height = currentFrameHeight
                            }
                        }
                        return currentHeight
                    }
                    .onTapGesture {
                        self.action(tag)
                    }
                }
            }
        }.frame(height : self.height)
            .animation(.easeInOut)
    }
}


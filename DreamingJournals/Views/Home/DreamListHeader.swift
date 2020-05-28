//
//  DreamListHeader.swift
//  DreamingJournals
//
//  Created by moesmoesie on 14/05/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import SwiftUI
import CoreData

struct ListHeader : View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View{
        let headerHeight = UIScreen.main.bounds.height / 2
        
        return
            ZStack(alignment:.bottom){
                Sky(mainHeight: headerHeight)
                Mountains(height: headerHeight)
                FilterButton()
                    .frame(maxWidth : .infinity, alignment: .trailing)
                    .padding(.trailing, .medium)
            }.frame(height  : headerHeight, alignment: .bottom)
    }
    

    
}

private struct FilterButton : View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var filterObserver : FilterObserver
    @EnvironmentObject var dreamStore : DreamStore

    @State var showFilterSheet  = false
    var body: some View{
        Button(action: {
            mediumFeedback()
            self.showFilterSheet = true
        }){
            HStack{
                Image(systemName: "magnifyingglass")
                    .imageScale(.medium)
                    .foregroundColor(.main2)
                Text("Filter")
                    .foregroundColor(.main2)
            }
        }
        .padding(.horizontal, .medium)
        .padding(.vertical,.small)
        .background(Color.background1)
        .cornerRadius(.medium)
        .primaryShadow()
        .sheet(isPresented: self.$showFilterSheet){
            LazyView(FilterSheet())
                .environment(\.managedObjectContext, self.managedObjectContext)
                .environmentObject(self.filterObserver)
                .environmentObject(self.dreamStore)

        }
    }
}


struct Sky : View {
    @Environment(\.colorScheme) var colorScheme
    let mainHeight : CGFloat
    var body: some View{
        let totalHeight = mainHeight * 10
        let isDarkmode = colorScheme == .dark
        return LinearGradient(
            gradient: Gradient.skyGradient(darkMode: isDarkmode,
                                           totalHeight: totalHeight,
                                           mainHeight: mainHeight),
            startPoint: .bottom,
            endPoint: .top)
            .frame(height : totalHeight)
    }
}

struct Mountains : View {
    let height : CGFloat
    var body: some View{
        Image("art1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth:UIScreen.main.bounds.width)
    }
}

struct DreamListHeader_Previews: PreviewProvider {
    static var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        ZStack{
            Color.background1.edgesIgnoringSafeArea(.all)
            VStack {
                ListHeader()
                    .environment(\.managedObjectContext, context)
                Spacer()
            }
        }
    }
}

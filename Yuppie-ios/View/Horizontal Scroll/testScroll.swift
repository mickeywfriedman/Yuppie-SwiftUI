//
//  testScroll.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI

struct testScroll: View {
    var buildings : [Building]
    @State var isFavorite = true
    var body: some View {
        ZStack{
    
            TabView {
                ForEach(buildings) {building in
                    CardView(building:building)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .offset(y:200)
        }.edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct testScroll_Previews: PreviewProvider {
    static var previews: some View {
        testScroll(buildings:TestData.buildings)
    }
}

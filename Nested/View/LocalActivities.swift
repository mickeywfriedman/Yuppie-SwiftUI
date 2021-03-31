//
//  LocalActivities.swift
//  Nested
//
//  Created by Ryan Cao on 3/29/21.
//

import SwiftUI

struct LocalActivities: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Local Gyms").font(.title).padding(.leading)
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(0..<10) {_ in
                        VStack{
                            Text("Gym Image")
                            .frame(width: 100, height: 100)
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                            Text("Gym Title")
                        
                        }.padding(.leading)
                    }
                }
            }.padding(.bottom)
            
            Text("Local Restaurants").font(.title).padding(.leading)
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(0..<10) {_ in
                        VStack{
                            Text("Restaurant Image")
                                .frame(width: 100, height: 100)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                            Text("Restaurant")
                        }.padding(.leading)
                    }
                }
            }.padding(.bottom)
            
            Text("Wifi Options").font(.title).padding(.leading)
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(0..<10) {_ in
                        VStack{
                            Text("Wifi Image")
                                .frame(width: 100, height: 100)
                                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                            Text("Wifi")
                        }.padding(.leading)
                    }
                }
            }.padding(.bottom)
        }
    }
}

struct LocalActivities_Previews: PreviewProvider {
    static var previews: some View {
        LocalActivities()
    }
}

//
//  TabBar.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 02/10/1399 AP.
//


import SwiftUI

struct TabBar: View {
    @State var currentTab = "house"
    @State var minBedrooms = 0
    @State var minBathrooms = 0
    @Binding var token: String
    @Binding var user_id: String
    @Binding var buildings : [Building]
    @Binding var user : User
    @Namespace var animation

    // safe area values...
    @State var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $currentTab){
                ZStack{
                IndexView(building: TestData.buildings.first!)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(tabs[0])
                    .background(Color("bg").ignoresSafeArea())
                    testScroll(token: $token, user_id: $user_id, buildings:buildings, user: $user, minBedrooms: $minBedrooms, minBathrooms: $minBathrooms)
                }
                Text("Edit Profile Page")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(tabs[1])
                    .background(Color("bg").ignoresSafeArea())
                
                Favorites(token: $token, user_id: $user_id, buildings:$buildings, user: $user, minBedrooms: $minBedrooms, minBathrooms: $minBathrooms)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(tabs[2])
                    .background(Color("bg").ignoresSafeArea())
                
            }
            
            // Custom Tab Bar....
            
            HStack(spacing: 35){
                
                ForEach(tabs,id: \.self){image in
                    
                    TabButton(image: image, selected: $currentTab, animation: animation)
                }
            }
            .padding(.horizontal,35)
            .padding(.top)
            .padding(.bottom,safeArea?.bottom != 0 ? safeArea?.bottom : 15)
            .background(
            
                LinearGradient(gradient: .init(colors: [Color("Color"), Color("Chat_color")]), startPoint: .top, endPoint: .bottom)
                    .clipShape(CustomCorner(corners: [.topLeft,.topRight]))
            )
        }
       
    }
}

var tabs = ["house","person","suit.heart"]

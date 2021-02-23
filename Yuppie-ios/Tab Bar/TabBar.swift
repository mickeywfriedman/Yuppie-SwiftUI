//
//  TabBar.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 02/10/1399 AP.
//

import SwiftUI



struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingScreen: View {
    @State private var animateLogo = false
    @State private var animateSmaller = false
    @State private var animateMedium = false
    @State private var animateLarger = false
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    var body: some View {
        ZStack {
            Image("background")
            .resizable()
                .edgesIgnoringSafeArea(.all)
            
            // Circle: Larger
            Circle()
                .frame(width: 212+80, height: 212+80)
                .foregroundColor(Color("Color1"))
                .opacity(0.5)
            .scaleEffect(animateLarger ? 1.2 : 0.5, anchor: .center)
                .animation(Animation.easeOut(duration: 0.3).repeatForever(autoreverses: true).delay(0.1))
                .onAppear() {
                    self.animateLarger.toggle()
            }
            
            // Circle: Medium
            Circle()
                .frame(width: 212+40, height: 212+40)
                .foregroundColor(Color("pgradient1"))
                .opacity(0.5)
                .scaleEffect(animateMedium ? 1.2 : 0.5, anchor: .center)
                .animation(Animation.easeOut(duration: 0.3).repeatForever(autoreverses: true).delay(0.05))
                .onAppear() {
                    self.animateMedium.toggle()
            }
            
            
            // Circle: Smaller
            Circle()
                .frame(width: 212, height: 212)
                .foregroundColor(Color("pgradient2"))
                .opacity(0.5)
                .scaleEffect(animateSmaller ? 1.2 : 0.5, anchor: .center)
                .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: true).delay(0.03))
                .onAppear() {
                    self.animateSmaller.toggle()
            }
            
            
            Image("small")
                .frame(width: 150)
                .scaleEffect(animateLogo ? 1 : 1.4, anchor: .center)
                .animation(Animation.easeOut(duration: 1).repeatForever(autoreverses: true))
                .onAppear() {
                    self.animateLogo.toggle()
            }
        }
    }
}

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
    @State var current = "Home"
    var profilePic: String
    var tabs = ["house","person","suit.heart"]
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $current){
                ZStack{
                    IndexView(buildings: $buildings)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(tabs[0])
                    if (buildings[0].name == "Test"){
                        LoadingScreen()
                    } else {
                    testScroll(token: $token, user_id: $user_id, buildings:buildings, user: $user)
                    }
                }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).tag("Home")
                ZStack{
                    UserProfile(token: $token, user_id: $user_id, buildings:$buildings, user: $user, minBedrooms: $minBedrooms, minBathrooms: $minBathrooms, profilePic: profilePic)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(tabs[1])
                }.tag("Profile")
                ZStack{
                Favorites(token: $token, user_id: $user_id, buildings:$buildings, user: $user, minBedrooms: $minBedrooms, minBathrooms: $minBathrooms)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(tabs[2])
                }.tag("Saved")
            }
            
            HStack(spacing: 0){
                
                // TabButton...
                
                
                TabButton(title: "Profile", image: "user", selected: $current)
                
                Spacer(minLength: 0)
                
                TabButton(title: "Home", image: "home", selected: $current)
                
                Spacer(minLength: 0)
                
                
                TabButton(title: "Saved", image: "heart-1", selected: $current)
            }
            .padding(.top,10)
            .padding(.bottom,30)
            .padding(.horizontal,25)
            .background(Color("pgradient1"))
            .shadow(color: Color("blueshadow").opacity(0.1),radius: 5,x: -5,y: -5)
            .shadow(color: Color.gray.opacity(0.86),radius: 7,x: 5,y: 5)
            
        }.background(LinearGradient(gradient: .init(colors: gradient), startPoint: .top, endPoint: .bottom))
    }

}

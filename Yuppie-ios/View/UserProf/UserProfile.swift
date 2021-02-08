//
//  UserProfile.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 19/11/1399 AP.
//

import Foundation
import SwiftUI

struct UserProfile : View {
    
    @Binding var token: String
    @Binding var user_id: String
    @Binding var buildings : [Building]
    @Binding var user : User
    @Binding var minBedrooms : Int
    @Binding var minBathrooms : Int
    @State var maxPrice = 10000.0
    @State var minDate = Date()
    @State var maxDate = Date(timeInterval: 14*86400, since: Date())
    
    @State var index = 0
    @State private var showFilters = false
    
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    
    func filter(units: [Unit]) -> Bool{
        for unit in units{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date_avail = dateFormatter.date(from: unit.dateAvailable)
            if (unit.bedrooms >= minBedrooms && unit.bathrooms >= minBathrooms && unit.price <= maxPrice && date_avail ?? Date() < maxDate){
                return true
            }
        }
        return false
    }
    
    func filterBuildings (buildings: [Building]) -> [Building] {
        var filteredBuildings = [Building]()
        for building in buildings{
            if (filter(units: building.units)){
                filteredBuildings.append(building)
            }
        }
        if (filteredBuildings.count==0){
            return [Building(
                id: "1",
                name: "No Matches",
                images: ["http://18.218.78.71:8080/images/5fdbefceae921a507c9785de","http://18.218.78.71:8080/images/5fdbefceae921a507c9785dd"],
                description: "Live life in luxary in one of the best apartment buildings in the city. 60 story Hudson Yards skyscraper just minutes away fro the mid-town.",
                address: Address(
                    streetAddress: "15 Bank Street",
                    city: "New York City",
                    state: "NY",
                    zipCode: 10036
                ),
                amenities: ["Pool", "Gym"],
                tenants: [tenant(
                    profilePicture: "http://18.218.78.71:8080/images/5fdbefceae921a507c9785de",
                    id: "5fd002a21ed3e413beb713d4",
                    firstName: "Leon"
                )],
                propertyManager: propertyManager(
                    email: "propertyManager1@gmail.com",
                    id: "5fd002a21ed3e413beb713d4"
                ),
                units: [
                    Unit(
                        number: "40H",
                        bedrooms: 2,
                        bathrooms: 2,
                        price: 3000,
                        squareFeet: 2000,
                        dateAvailable: "Today",
                        floorPlan: "http://18.218.78.71:8080/images/5fdb99bcae921a507c9785cc"
                    )
                ]
                )]
        }
        return filteredBuildings
    }
    
    var body: some View{
        
        VStack{
            
            HStack(spacing: 15){
                
               
                
                Text("Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Chat_color"))
                
                Spacer(minLength: 0)
                
                Button(action: {
                    
                }) {
                    
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background(Color("Chat_color"))
                        .cornerRadius(10)
                }
            }
            .padding()
            
            HStack{
                
                VStack(spacing: 0){
                    
                    Rectangle()
                    .fill(Color("Color"))
                    .frame(width: 80, height: 3)
                    .zIndex(1)
                    
                    
                    // going to apply shadows to look like neuromorphic feel...
                    
                    URLImage(url: "\(user.profilePicture)")
                    .frame(width: 100, height: 100)
                    .padding(.top, 6)
                    .padding(.bottom, 4)
                    .padding(.horizontal, 8)
                    .background(Color("Color1"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                    .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                }
                
                VStack(alignment: .leading, spacing: 12){
                    
                    Text("Hello, \(user.firstName)")
                        .font(.title)
                        .foregroundColor(Color.black.opacity(0.8))
                    
                    Text("\(user.email)")
                        .foregroundColor(Color.black.opacity(0.7))
                        .padding(.top, 8)
                    
                    Text("UChicago")
                        .foregroundColor(Color.black.opacity(0.7))
                }
                .padding(.leading, 20)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Tab Items...
            // Tab View...
            
            HStack(spacing: 0){
                
                Text("My Preferences")
                    .foregroundColor(self.index == 0 ? .white : Color("Chat_color").opacity(0.7))
                    .fontWeight(.bold)
                    .padding(.vertical,10)
                    .padding(.horizontal,35)
                    .background(Color("Chat_color").opacity(self.index == 0 ? 1 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        
                        withAnimation(.default){
                        
                            self.index = 0
                        }
                    }
                
                Spacer(minLength: 0)
                
                
                
                Text("My Building")
                    .foregroundColor(self.index == 1 ? .white : Color("Chat_color").opacity(0.7))
                    .fontWeight(.bold)
                    .padding(.vertical,10)
                    .padding(.horizontal,35)
                    .background(Color("Chat_color").opacity(self.index == 1 ? 1 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        
                        withAnimation(.default){
                        
                            self.index = 1
                        }
                    }
            }
            .background(Color.black.opacity(0.06))
            .clipShape(Capsule())
            .padding(.horizontal)
            .padding(.top,25)
            
            TabView(selection: self.$index){

                // week data..
                FiltersView(showFilters: self.$showFilters, token: $token, user: $user, user_id: $user_id, minDate: dateFormat(string: user.preferences.earliestMoveInDate), maxDate: dateFormat(string: user.preferences.latestMoveInDate))

                // month data...
                
                BuildingGallery()

              

                VStack{

                    Text("Monthly Data")
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Cards...
            
           
            
            Spacer(minLength: 0)
        }
        .background(Color("Color1").edgesIgnoringSafeArea(.all))
    }
}

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
    @State var showSheet = false
    @State var sheet = ""
    var profilePic : String
    func logout() -> Void {
        self.user_id = ""
        UserDefaultsService().removeUserInfo()
    }
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    func filter(units: [Unit], buildingAmenities: [String]) -> Bool{
        for unit in units{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date_avail = dateFormatter.date(from: unit.dateAvailable)
            if (unit.bedrooms >= user.preferences.bedrooms && unit.bathrooms-1 >= user.preferences.bathrooms && Int(unit.price) <= Int(user.preferences.price) && date_avail ?? Date() < dateFormat(string: user.preferences.latestMoveInDate)){
                for amenity in user.preferences.amenities {
                    if (!buildingAmenities.contains(amenity)){
                        return false
                    }
                }
                return true
            }
        }
        return false
    }
    func filteredBuildings() -> [Building]{
        return buildings.filter({filter(units: $0.units, buildingAmenities:$0.amenities)})
    }
    var body: some View{
        VStack(spacing: 0){
            HStack{
                Text("Profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("Chat_color"))
                Spacer()
            }.padding()
            .sheet(isPresented: $showSheet) {
                profileSheets(card: $sheet, showCard: $showSheet, user: $user, buildings: buildings, user_id: $user_id, token:$token, index: $index)
            }
            profileView(profilePic: profilePic, firstName: user.firstName, university: user.university, user_id: $user_id).padding(.vertical)
            ScrollView{
            VStack(spacing: 0){
                Divider()
                profileRow(text: "Edit Profile").onTapGesture {
                    sheet = "edit"
                    showSheet = true
                }
                profileRow(text: "My Building").onTapGesture {
                    sheet = "building"
                    showSheet = true
                }
                profileRow(text: "Search Preferences").onTapGesture {
                    sheet = "filter"
                    showSheet = true
                }
                profileRow(text: "Terms and Conditions").onTapGesture {
                    sheet = "terms"
                    showSheet = true
                }
                profileRow(text: "Privacy Policy").onTapGesture {
                    sheet = "privacy"
                    showSheet = true
                }
                profileRow(text: "Submit Feedback").onTapGesture {
                    sheet = "feedback"
                    showSheet = true
                }
                profileRow(text: "Contact Us").onTapGesture {
                    sheet = "contact"
                    showSheet = true
                }
                profileRow(text: "Logout").onTapGesture {
                    logout()
                }
                Divider()
            }
            }.padding(.top)
            Spacer()
        }
    }
}


struct profileView : View {
    var profilePic: String
    var firstName: String
    var university: University
    @State var showSettings = false
    @Binding var user_id: String
    func logout() -> Void {
        self.user_id = ""
        UserDefaultsService().removeUserInfo()
    }
    var body : some View{
        HStack{
            
            VStack(spacing: 0){
                
                Rectangle()
                .fill(Color("Color"))
                .frame(width: 80, height: 3)
                .zIndex(1)
                
                
                // going to apply shadows to look like neuromorphic feel...
                
                ImageView(url: "\(profilePic)")
                .frame(width: 100, height: 100)
                .background(Color("Color1"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 12){
                
                Text("Hello, \(firstName)")
                    .font(.title)
                Text("\(university.name)")
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal)

        // Tab Items...
        // Tab View...
    }}

struct profileRow: View {
    var text: String
    var body: some View {
        Divider()
        HStack{
            Text(text)
            Spacer()
            Image(systemName: "chevron.right")
        }.padding(.vertical)
        .padding(.horizontal)
        .contentShape(Rectangle())
        Divider()
    }
}

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
    
    var profilePic : String
    func format(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    func updateFilters() -> Void {
        self.user.preferences.earliestMoveInDate = "\(format(date: minDate))"
        self.user.preferences.latestMoveInDate = "\(format(date: maxDate))"
        guard let filter_url = URL(string: "http://18.218.78.71:8080/users/\(user_id)") else {
            print("Your API end point is Invalid")
            return
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(update(preferences: user.preferences)) else {
            print("Failed to encode order")
            return
        }
        var filter_request = URLRequest(url: filter_url)
        filter_request.httpMethod = "PATCH"
        filter_request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        filter_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        filter_request.httpBody = data
        print("updated")
        URLSession.shared.dataTask(with: filter_request) { data, response, error in
            return
            
        }.resume()
    }
    
    var body: some View{
        
        VStack{
            
            ProfileView(profilePic: profilePic, firstName: user.firstName, university: user.university, user_id: $user_id).padding()
            
            HStack(spacing: 0){
                
                Text("Preferences")
                    .foregroundColor(self.index == 0 ? .white : Color("Chat_color").opacity(0.7))
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.bold)
                    .padding(.vertical,10)
                    .padding(.horizontal,30)
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
                    .font(.custom("Futura", size: 16))
                    .fontWeight(.bold)
                    .padding(.vertical,10)
                    .padding(.horizontal,30)
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
            .padding()
            
            if (index == 0){

                // week data..
                FiltersView(token: $token, user: $user, user_id: $user_id, minDate: dateFormat(string: user.preferences.earliestMoveInDate), maxDate: dateFormat(string: user.preferences.latestMoveInDate)).tag(0)
            } else if (index == 1){
                // month data...
                
                BuildingGallery(buildings: buildings, user: $user, token: token).tag(1)
            }
            else if (index == 2){

                VStack{

                    Text("Monthly Data")
                }

            }
            // Cards...
            
           
            
            Spacer(minLength: 0)
        }
        .onDisappear(perform: updateFilters)
    }
}



struct ProfileView : View {
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
        HStack(spacing: 15){

            Text("Profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("Chat_color"))
                .sheet(isPresented: $showSettings) {
                    Settings(user_id : $user_id, showSettings: $showSettings)
            }
            Spacer(minLength: 0)
            
                Image(systemName: "gear")
                    .foregroundColor(Color.white)
                    .padding(.vertical,8)
                    .padding(.horizontal,10)
                    .background(Color("Chat_color"))
                    .clipShape(Circle())
                    .onTapGesture {
                        showSettings = true
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
                
                ImageView(url: "\(profilePic)")
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
                
                Text("Hello, \(firstName)")
                    .font(.title)
                Text("\(university.name)")
            }
            .padding(.leading, 20)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)

        // Tab Items...
        // Tab View...
    }}

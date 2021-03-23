//  ContentView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//
import SwiftUI
import Mapbox

struct CentralHomeView: View {

    @State private var menuItemSize: CGFloat = 66
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    @State private var user = TestData.user
    @State private var buildingsData = TestData.buildings
    @Binding var showCard : Bool
    @State var buildingId : String
    func loadData() {
        if (self.token != "") {
            print(self.token, "SUHSHHHS")
            guard let url = URL(string: "http://18.218.78.71:8080/buildings") else {
                print("Your API end point is Invalid")
                return
            }
            var request = URLRequest(url: url)
            request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            print(self.token)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let response = try? JSONDecoder().decode(Response.self, from: data) {
                        DispatchQueue.main.async {
                            self.buildingsData = response.data
                            print("hello")
                            print(user_id)
                        }
                        return
                    }
                }
            }.resume()
        }
        }
    func loadUser() {
        if (self.token != "") {
            guard let user_url = URL(string: "http://18.218.78.71:8080/users/\(self.user_id)") else {
                print("Your API end point is Invalid")
                return
            }
            var user_request = URLRequest(url: user_url)
            user_request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: user_request) { data, response, error in
                if let data = data {
                    print(self.token)
                    print(self.user_id)
                    if let urlresponse = try? JSONDecoder().decode(userResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.user = urlresponse.data
                            print("success")
                            print(self.user)
                        }
                        return
                    }
                    
                }
            }.resume()
        }
        }
        // MARK: - Helper
        
        


    
    // MARK: - Helper
    
    

    
    // MARK: - Body
    
    var body: some View {
            VStack {
                Spacer()
                ZStack(alignment: .leading) {
                    
                    TabBar(showCard: $showCard, buildingId: buildingId, token: $token, user_id: $user_id, buildings: $buildingsData, user: $user, profilePic: user.profilePicture)
                }.edgesIgnoringSafeArea(.all)
            }
            .onAppear(perform: loadUser)
            .onAppear(perform: loadData)
            .edgesIgnoringSafeArea(.all)
            
        }
    
   
}


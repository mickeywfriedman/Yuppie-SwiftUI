//  ContentView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//
import SwiftUI
import Mapbox

struct CentralHomeView: View {
    
   
    
    
  
    
    @State private var indexView = IndexView(building: TestData.buildings.first!)
    
    @State private var menuItemSize: CGFloat = 66
    @State private var authToken: String = UserDefaults.standard.string(forKey: "Token") ?? ""
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    @State var user = User(
        id: "1",
        firstName: "Test",
        lastName: "User"
    )
    @State private var buildingsData = TestData.buildings
    func loadData() {
            guard let url = URL(string: "http://18.218.78.71:8080/buildings") else {
                print("Your API end point is Invalid")
                return
            }
            var request = URLRequest(url: url)
        print("hello")
        print(token)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let response = try? JSONDecoder().decode(Response.self, from: data) {
                        DispatchQueue.main.async {
                            self.buildingsData = response.data
                        }
                        return
                    }
                    
                }
            }.resume()
        }
    func loadUser() {
        print("asdfhjjhklasdjkhfjdska")
        print(user_id)
        print(token)
        guard let user_url = URL(string: "http://18.218.78.71:8080/users/\(user_id)") else {
                print("Your API end point is Invalid")
                return
            }
            var user_request = URLRequest(url: user_url)
            user_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: user_request) { data, response, error in
                if let data = data {
                    if let urlresponse = try? JSONDecoder().decode(userResponse.self, from: data) {
                        print("hello")
                        DispatchQueue.main.async {
                            self.user = urlresponse.data
                            print(urlresponse.data)
                        }
                        return
                    }
                    
                }
            }.resume()
        }
        // MARK: - Helper
        
        


    
    // MARK: - Helper
    
    

    
    // MARK: - Body
    
    var body: some View {
        
        
        
        var visibleCard =  testScroll(token: $token, user_id: $user_id, buildings:buildingsData)
        
        return
            
                VStack {
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        
                        
                        
                        
                        // selected card index view
                        self.indexView
                        
                        TabBar()
                        //Home(buildings:buildingsData)
                        
                       
                            VStack{
                               
                                visibleCard
                                
                            }
                       // if self.authToken == "" {
                          //  NavigationView{LoginView(didLogin: $didLogin, needsAccount: $needsAccount, random: $random, token: $authToken)}
                      //  }
                        
//                        if self.needsAccount == true && token == "" {
//                            NavigationView{
//                                SignupView(user_id: $user_id, didLogin: $didLogin, needsAccount: $needsAccount, token: $authToken)}
//
//
//                       }
//
                        
                        
                        
                        
                       // SignupView()
                       // Registration()
                        
                    }
                    
                    
                       
                        
                    
                   
                        
                        
                }
            .onAppear(perform: loadData)
            .onAppear(perform: loadUser)
            .edgesIgnoringSafeArea(.all)
            
        }
    
   
}


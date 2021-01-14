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
    @State private var buildingsData = TestData.buildings
    
    func printUserId() {
        
        print(self.user_id+"bip")
        print(self.token+"AUTHPAST")
        print(self.didLogin)
        
    }
        func loadData() {
            printUserId()
                guard let url = URL(string: "http://18.218.78.71:8080/buildings") else {
                    print("Your API end point is Invalid")
                    return
                }
                let request = URLRequest(url: url)

                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let response = try? JSONDecoder().decode(Response.self, from: data) {
                            print(response)
                            DispatchQueue.main.async {
                                self.buildingsData = response.data
                                print(response.data)
                            }
                            return
                        }
                        print(response)
                        
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
            .edgesIgnoringSafeArea(.all)
            
        }
    
   
}


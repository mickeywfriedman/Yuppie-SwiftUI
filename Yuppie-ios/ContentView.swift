//
//  ContentView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//

import SwiftUI
import Mapbox

struct ContentView: View {
    
   
    
    
  
    
    @State private var indexView = IndexView(building: TestData.buildings.first!)
    
    @State private var menuItemSize: CGFloat = 66
    @State private var authToken: String = UserDefaults.standard.string(forKey: "Token") ?? ""
    @State var didLogin: Bool = false
    @State var needsAccount: Bool = true
    @State var user_id: String = ""
    @State var token: String = ""
    @State private var buildingsData = TestData.buildings
    func loadData() {
            guard let url = URL(string: "http://18.218.78.71:8080/buildings") else {
                print("Your API end point is Invalid")
                return
            }
            let request = URLRequest(url: url)

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
    
    // MARK: - Helper
    
    

    
    // MARK: - Body
    
    var body: some View {
        
        
        return
            
                VStack {
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        
                        
                        
                        
                        // selected card index view
                      
                       // if self.authToken == "" {
                          //  NavigationView{LoginView(didLogin: $didLogin, needsAccount: $needsAccount, random: $random, token: $authToken)}
                      //  }
                        
                        
                        
                        if self.needsAccount == true{
                            NavigationView{
                                SignupView(user_id: $user_id, didLogin: $didLogin, needsAccount: $needsAccount, token: $authToken)}


                        }else{
                            CentralHomeView(token: $authToken, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id)
                        }
                        
                        
                        
                        
                       // SignupView()
                       // Registration()
                        
                    }
                    
                    
                       
                        
                    
                   
                        
                        
                }
            .onAppear(perform: loadData)
            .edgesIgnoringSafeArea(.all)
            
        }
    
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

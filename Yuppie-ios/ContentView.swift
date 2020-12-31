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
    @State private var didLogin: Bool = false
    @State private var needsAccount: Bool = true
    @State private var random: Bool = false
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
                        print(response)
                        DispatchQueue.main.async {
                            self.buildingsData = response.data
                        }
                        return
                    }
                    print(response)
                }
            }.resume()
        }
    
    // MARK: - Helper
    
    

    
    // MARK: - Body
    
    var body: some View {
        
        
        var visibleCard =  testScroll(buildings:buildingsData)
        
        return
            
                VStack {
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        
                        
                        
                        
                        // selected card index view
                        self.indexView
                        
                        TabBar()
                        Home()
                        
                       
                            VStack{
                               
                                visibleCard
                                
                            }
                       // if self.authToken == "" {
                          //  NavigationView{LoginView(didLogin: $didLogin, needsAccount: $needsAccount, random: $random, token: $authToken)}
                      //  }
                        
                      //  if self.needsAccount == true{
                       //     NavigationView{
                          //      SignupView(didLogin: $didLogin, needsAccount: $needsAccount, random: $random, token: $authToken)}
                      // }
                    
                        
                        
                        
                        
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

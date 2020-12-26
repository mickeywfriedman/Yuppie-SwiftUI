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

    
    // MARK: - Helper
    
    

    
    // MARK: - Body
    
    var body: some View {
        
        
        
        var visibleCard =  testScroll(buildings:TestData.buildings)
        
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
              
            .edgesIgnoringSafeArea(.all)
            
        }
    
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

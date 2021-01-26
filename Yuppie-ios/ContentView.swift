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
    
    // MARK: - Helper
    
    

    
    // MARK: - Body
    
    var body: some View {
        
        
        return
            
                VStack {
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {

                        if self.authToken == ""{
                            NavigationView{
                                SignupView(user_id: $user_id, didLogin: $didLogin, needsAccount: $needsAccount, token: $authToken)}


                        } else{
                            CentralHomeView(token: $authToken, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id)
                        }

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

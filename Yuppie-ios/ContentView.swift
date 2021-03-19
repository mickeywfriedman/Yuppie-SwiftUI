//
//  ContentView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//

import SwiftUI
import Mapbox

struct ContentView: View {
    @State var showCard: Bool
    @State private var menuItemSize: CGFloat = 66
    @State private var authToken: String = UserDefaults.standard.string(forKey: "Token") ?? ""
    @State var didLogin: Bool = false
    @State var needsAccount: Bool = true
    @State var user_id: String = ""
    @State var token: String = ""
    @State var buildingId: String
    var body: some View {
        return
            
                VStack {
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {

                        if (self.user_id == "" || self.needsAccount){
                            NavigationView{
                                PhoneAuth(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id)}


                        }
                        else {
                            CentralHomeView(token: self.$token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id, showCard: self.$showCard, buildingId: buildingId)
                        }

                    }

                }
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: checkIfLoggedIn)
            
        }
    
    func checkIfLoggedIn() {
        print("test")
        let auth_info = UserDefaultsService().getUserInfo()
        if (auth_info.token != ""  && auth_info.id != "") {
            let token = auth_info.token!
            let user_id = auth_info.id!
            guard let user_url = URL(string: "http://18.218.78.71:8080/authentication/token/\(user_id)") else {
                print("Your API end point is Invalid")
                return
            }
            var user_request = URLRequest(url: user_url)
            user_request.httpMethod = "POST"
            user_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: user_request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.user_id = user_id
                        self.token = token
                        self.needsAccount = false
                    }
                }
            }.resume()
        }
    }
   
}


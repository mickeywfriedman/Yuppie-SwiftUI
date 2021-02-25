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
            
        }
    
   
}


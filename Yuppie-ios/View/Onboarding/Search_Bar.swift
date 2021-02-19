//
//  Search_Bar.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 28/11/1399 AP.
//

import Foundation
import SwiftUI

struct Search_Bar: View {
    
    @StateObject var searchData = SearchUsers()
    @State var rec = ""
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var token: String
    @Binding var user_id: String
    
    var body: some View {
        
        VStack{
            CustomSearchBar(searchData:searchData, didLogin: $didLogin, needsAccount: $needsAccount, token: $token, user_id: $user_id)
            
            Spacer()
            
        }.onChange(of: searchData.query) {(newData) in
            print(newData)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                if newData == searchData.query{
                    print("search \(newData)")
                    
                    
                    if searchData.query != ""{
                        searchData.searchedUser.removeAll()
                        searchData.find()
                        
                    }
                }
            }
        }
    }
}

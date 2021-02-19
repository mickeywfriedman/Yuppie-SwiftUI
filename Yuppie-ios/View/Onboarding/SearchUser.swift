//
//  SearchUser.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 27/11/1399 AP.
//

import SwiftUI

class SearchUsers: ObservableObject {
    
    @Published var searchedUser = TestData.buildings
    @Published var query = ""
    


    func find(){
        
        guard let url = URL(string: "http://18.218.78.71:8080/buildings") else {
            print("Your API end point is Invalid")
            return
        }
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MTMxMjk4MzcsIm5iZiI6MTYxMzEyOTgzNywianRpIjoiOTk4N2RlOTYtNzE0Mi00NTI3LWE4YWYtMTA2NDYxNWVlZjU5IiwiaWRlbnRpdHkiOiI2MDFiODM4MDZjYmQ5ZjY4ZDk0MWI2ZDYiLCJmcmVzaCI6ZmFsc2UsInR5cGUiOiJhY2Nlc3MifQ.dJylhJ6mi07rlU819Pbhsgr-YZAF3u8Gkrteavd9nMw"
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let jsonData = data else{return}
            
            do{
                let users = try JSONDecoder().decode(Response.self, from: jsonData)
                
                DispatchQueue.main.async {
                    self.searchedUser.append(contentsOf: users.data)
                    print(users.data)
                    
                }
            } catch{
                print(error.localizedDescription)
            }
        }.resume()
        
        }
}

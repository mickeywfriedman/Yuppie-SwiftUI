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
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    

    func find(){
        
        guard let url = URL(string: "http://18.218.78.71:8080/buildings") else {
            print("Your API end point is Invalid")
            return
        }
        let url_file = self.getDocumentsDirectory().appendingPathComponent("index.txt")
        do{
        let input = try String(contentsOf: url_file)
        let tenant_id = String(input[0..<24])
        let token = input.substring(fromIndex: 57)
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
            
        }catch {
            print(error.localizedDescription)
        }
        
        }
}

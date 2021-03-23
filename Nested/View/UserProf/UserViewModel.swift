//
//  UserViewModel.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 19/11/1399 AP.
//


import SwiftUI

class UserViewModel: ObservableObject{
    var user = TestData.user
    var building = TestData.building
    
    // Search...
    @Published var search = ""
    
    // Compositional Layout Array...
    
    init() {
        loadUser()
        loadData(building: self.user.building)
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
    func loadData(building: String) {

            let url_file = self.getDocumentsDirectory().appendingPathComponent("index.txt")
                    do {
                        let input = try String(contentsOf: url_file)
                        let user_id = String(input[24..<48])
                        let token = input.substring(fromIndex: 57)
            guard let url = URL(string: "http://18.218.78.71:8080/buildings/\(building)") else {
                print("Your API end point is Invalid")
                return
            }
            var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let urlresponse = try? JSONDecoder().decode(BuildingResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.building = urlresponse.data
                            print("success")
                            print(self.building)

                        }
                        return
                    }
                    
                }
            }.resume()}catch {
                print(error.localizedDescription)
            }
        }
    
    func loadUser() {
        
        let url_file = self.getDocumentsDirectory().appendingPathComponent("index.txt")

                do {
                    let input = try String(contentsOf: url_file)
                    
                    let tenant_id = String(input[0..<24])
                    let user_id = String(input[24..<48])
                    let token = input.substring(fromIndex: 57)
        guard let user_url = URL(string: "http://18.218.78.71:8080/users/\(user_id)") else {
                print("Your API end point is Invalid")
                return
            }
            var user_request = URLRequest(url: user_url)
            user_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: user_request) { data, response, error in
                if let data = data {
                    if let urlresponse = try? JSONDecoder().decode(userResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.user = urlresponse.data
                            self.loadData(building: self.user.building)
                        }
                        return
                    }
                    
                }
            }.resume()
                    
                }catch {
                    print(error.localizedDescription)
                }

        }

}

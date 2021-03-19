//
//  UserService.swift
//  Yuppie-ios
//
//  Created by Brendan Sanderson on 3/10/21.
//

import Foundation


class UserService: BaseService {
    static let shared = BaseService()
    var getUrl: URL?
    var user: User?
    override private init() {
        super.init()
        if (self.url != nil && self.userId != nil) {
            self.getUrl = URL(string: self.url!+"/user\(self.userId!)")
        }
    }
    
    func get(user_id: String, user: inout User) {
        if (self.getUrl == nil) {
            (self.userId, self.token) = UserDefaultsService.shared.getUserInfo()
            self.getUrl = URL(string: self.url!+"/user\(self.userId!)")
        }
        var request = URLRequest(url: self.getUrl!)
        request.httpMethod = "get"
        self.user = user
        super.request(urlRequest: request, completionHandler: setUser)
    }
    
    func setUser(data:Data?, response: URLResponse?, error: NSError?) {
        guard let data = data else {
            return;
        }
        if let urlresponse = try? JSONDecoder().decode(UserResponse.self, from: data) {
            DispatchQueue.main.async {
                self.user = urlresponse.data
                print("successfully set user with id \(self.userId)")
                print(self.user)
            }
        }
    }
}

//
//  BaseService.swift
//  Yuppie-ios
//
//  Created by Brendan Sanderson on 3/10/21.
//

import Foundation
import Alamofire

struct ApiResponse {
    let error: Error?
    let data: Data?
}

class BaseService {
    
    var userId: String?
    var token: String?
    var url: String?
    
    public init() {
        (self.userId, self.token) = UserDefaultsService.shared.getUserInfo()
        self.url = Bundle.main.infoDictionary!["API_URL"] as? String
    }
    
    func request(url: String, method: HTTPMethod, headers: [String:String] = [:]) {
        var h = headers
        if ((self.token == nil)) {
            (self.userId, self.token) = UserDefaultsService.shared.getUserInfo()
        }
        h["Authorization"] = "Bearer \(self.token ?? "")"
        return requestWithoutAuth(url: url, method: method, headers: h)
    }
    
    func requestWithoutAuth(url: String,  method: HTTPMethod, headers: [String:String] = [:]) {
        var h = headers
        h["Content-Type"] = "application/json"
        h["Accept"] = "*/*"
        AF.request(url, method: method, headers: HTTPHeaders(headers))
        .validate()
        .responseDecodable
        
        task.resume()
    }
}

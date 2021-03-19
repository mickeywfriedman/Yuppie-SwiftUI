//
//  UserDefaultsService.swift
//  Yuppie-ios
//
//  Created by Brendan Sanderson on 3/10/21.
//

import Foundation

class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    struct defaultsKeys {
        static let idKey = "id"
        static let tokenKey = "token"
    }
    enum Key: String, CaseIterable {
        case id, token
        func make(for userID: String) -> String {
            return self.rawValue + "_" + userID
        }
    }
    let userDefaults: UserDefaults
    // MARK: - Lifecycle
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    // MARK: - API
    func storeInfo(id: String, token: String) {
        userDefaults.set(id, forKey: defaultsKeys.idKey)
        userDefaults.set(token, forKey: defaultsKeys.tokenKey)
    }
    
    func getUserInfo() -> (id: String?, token: String?) {
        let id: String? = userDefaults.string(forKey: defaultsKeys.idKey)
        let token: String? = userDefaults.string(forKey: defaultsKeys.tokenKey)
        return (id, token)
    }
    
    func removeUserInfo() {
        userDefaults.removeObject(forKey: defaultsKeys.idKey)
        userDefaults.removeObject(forKey: defaultsKeys.tokenKey)
    }
}

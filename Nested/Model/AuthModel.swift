//
//  AuthModel.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 03/12/1399 AP.
//

import Foundation
import SwiftUI

struct Authentication: Decodable{
    var access_token: String
    var needsAccount: Bool
    var refresh_token: String
    var user_id: String
}

struct authResponse: Decodable {
    var result : Authentication
}

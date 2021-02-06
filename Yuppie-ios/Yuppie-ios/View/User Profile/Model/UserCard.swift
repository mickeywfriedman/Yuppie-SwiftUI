//
//  Card.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/11/1399 AP.
//

import SwiftUI

struct UserCard: Identifiable,Decodable,Hashable {

    var id: String
    var download_url: String
    var author: String
}


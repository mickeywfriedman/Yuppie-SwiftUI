//
//  MessageModel.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 19/11/1399 AP.
//

import SwiftUI
import Foundation


struct Conversation: Hashable, Decodable{
    var user1: String
    var messages: [Message1]

}

struct Message1: Hashable, Decodable, Identifiable{
    var id : String
    var sender : String
    var sentTime: String
    var message : String
    var type : Int
}



struct Messages: Hashable, Codable, Identifiable{
    var id : String
    var sender : String
    var sentTime: String
    var message : String
    var type : Int
}




struct messageResponse: Decodable {
    var data : Conversation
}

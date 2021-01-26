import SwiftUI
import Foundation

struct User: Hashable, Decodable{
    var firstName: String
    var lastName: String
    var contacted: [String]
    var favorites: [String]
}

struct userResponse: Decodable {
    var data : User
}

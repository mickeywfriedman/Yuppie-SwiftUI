import SwiftUI
import Foundation

struct User: Hashable, Decodable{
    var id: String
    var firstName: String
    var lastName: String
}

struct userResponse: Decodable {
    var data : User
}

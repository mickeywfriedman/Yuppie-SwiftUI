import SwiftUI
import Foundation

struct User: Codable{
    var firstName: String
    var lastName: String
    var building: String
    var profilePicture: String
    var contacted: [String]
    var favorites: [String]
    var preferences: preferences
    var id: String
    var university: University
    var email: String
    var emailVerified: Bool
}

struct userResponse: Codable {
    var data : User
}

struct preferences: Codable {
    var bedrooms: Int
    var bathrooms: Int
    var price: Double
    var amenities: [String]
    var earliestMoveInDate: String
    var latestMoveInDate: String
    
}

struct update: Codable {
    var preferences: preferences
}

import SwiftUI
import Foundation

struct User: Codable{
    var firstName: String
    var lastName: String
    var contacted: [String]
    var favorites: [String]
    var preferences: preferences
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

import SwiftUI


struct Building: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var images: [String]
    var description: String
    var address: String
    var amenities: [String]
    var units: [Unit]
}

struct Unit: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var bedrooms: String
    var bathrooms: String
    var price: String
    var sqft: String
}

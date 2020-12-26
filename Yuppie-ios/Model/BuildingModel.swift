//
//  BuildingModel.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI


struct Building: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var images: [String]
    var description: String
    var address: String
    var amenities: [String]
    var latitude: Float
    var longitude: Float
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

//
//  BuildingModel.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI
import Foundation

struct Building: Hashable, Decodable{
    var id: String
    var name: String
    var images: [String]
    var description: String
    var address: Address
    var amenities: [String]
    var tenants: [tenant]
    var propertyManager: propertyManager
    var units: [Unit]
    var latitude: Float
    var longitude: Float
}

struct BuildingResponse: Decodable {
    var data : Building
}

struct UnitResponse: Decodable {
    var result : [String]
}

struct Unit: Hashable, Decodable{
    var number: String
    var bedrooms: Int
    var bathrooms: Int
    var price: Double
    var squareFeet: Int
    var dateAvailable: String
    var floorPlan: String
}

struct Address: Hashable, Decodable{
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: Int
}


struct tenant: Hashable, Decodable{
    var profilePicture: String
    var id: String
    var firstName: String
}

struct propertyManager: Hashable, Codable{
    var id: String
}

struct Response: Decodable {
    var data : [Building]
}

struct Lead: Codable {
    var message: String
    var buildingId: String
    var user: String
    var propertyManager: String
    var propertyName: String
    var unitEnquired: String
    var moveInDate: String
}

struct Email: Codable {
    var email: String
}

//
//  TestData.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//

import UIKit


enum TestData {
    static let user = User(
        firstName: "Test",
        lastName: "User",
        building: "5fdae6afedf9ef3d1f7c215c",
        profilePicture: "asdlfkdslf.com",
        contacted: [],
        favorites: [],
        preferences: preferences(bedrooms: 0, bathrooms: 0, price: 10000.0, amenities: [], earliestMoveInDate: "2020-01-26", latestMoveInDate: "2021-01-26"),
        id: "a;dlsfkjs;dfda"
    )
    
    static let building = Building(
        id: "1",
        name: "Test",
        images: ["http://18.218.78.71:8080/images/5fdbefceae921a507c9785de"],
        description: "Live life in luxary in one of the best apartment buildings in the city. 60 story Hudson Yards skyscraper just minutes away fro the mid-town.",
        address: Address(
            streetAddress: "15 Bank Street",
            city: "New York City",
            state: "NY",
            zipCode: 10036
        ),
        
        amenities: ["Pool", "Gym"],
        tenants: [tenant(
            profilePicture: "http://18.218.78.71:8080/images/5fdbefceae921a507c9785de",
            id: "5fd002a21ed3e413beb713d4",
            firstName: "Leon"
        )],
        propertyManager: propertyManager(
            id: "5fd002a21ed3e413beb713d4"
        ),
        units: [
            Unit(
                number: "40H",
                bedrooms: 2,
                bathrooms: 2,
                price: 3000,
                squareFeet: 2000,
                dateAvailable: "Today",
                floorPlan: "http://18.218.78.71:8080/images/5fdb99bcae921a507c9785cc"
            )
        ]
    
    )

    
    static let buildings = [
        Building(
            id: "1",
            name: "Test",
            images: ["http://18.218.78.71:8080/images/5fdbefceae921a507c9785de"],
            description: "Live life in luxary in one of the best apartment buildings in the city. 60 story Hudson Yards skyscraper just minutes away fro the mid-town.",
            address: Address(
                streetAddress: "15 Bank Street",
                city: "New York City",
                state: "NY",
                zipCode: 10036
            ),
            
            amenities: ["Pool", "Gym"],
            tenants: [tenant(
                profilePicture: "http://18.218.78.71:8080/images/5fdbefceae921a507c9785de",
                id: "5fd002a21ed3e413beb713d4",
                firstName: "Leon"
            )],
            propertyManager: propertyManager(
                id: "5fd002a21ed3e413beb713d4"
            ),
            units: [
                Unit(
                    number: "40H",
                    bedrooms: 2,
                    bathrooms: 2,
                    price: 3000,
                    squareFeet: 2000,
                    dateAvailable: "Today",
                    floorPlan: "http://18.218.78.71:8080/images/5fdb99bcae921a507c9785cc"
                )
            ]
            )
    ]
}

enum InitialData {
    
    
    static let buildings = [
        Building(
            id: "1",
            name: " ",
            images: ["http://18.218.78.71:8080/images/5fdbefceae921a507c9785de"],
            description: " ",
            address: Address(
                streetAddress: " ",
                city: " ",
                state: " ",
                zipCode: 0
            ),
            amenities: [],
            tenants: [tenant(
                profilePicture: "http://18.218.78.71:8080/images/5fdbefceae921a507c9785de",
                id: "5fd002a21ed3e413beb713d4",
                firstName: "Leon"
            )],
            propertyManager: propertyManager(
                id: "5fd002a21ed3e413beb713d4"
            ),
            units: [
                Unit(
                    number: " ",
                    bedrooms: 0,
                    bathrooms: 0,
                    price: 0,
                    squareFeet: 0,
                    dateAvailable: " ",
                    floorPlan: ""
                )
            ]
            ),
        Building(
            id: "1",
            name: " ",
            images: ["http://18.218.78.71:8080/images/5fdbefceae921a507c9785de"],
            description: " ",
            address: Address(
                streetAddress: " ",
                city: " ",
                state: " ",
                zipCode: 0
            ),
            amenities: [],
            tenants: [tenant(
                profilePicture: "http://18.218.78.71:8080/images/5fdbefceae921a507c9785de",
                id: "5fd002a21ed3e413beb713d4",
                firstName: "Leon"
            )],
            propertyManager: propertyManager(
                id: "5fd002a21ed3e413beb713d4"
                
            ),
            units: [
                Unit(
                    number: " ",
                    bedrooms: 0,
                    bathrooms: 0,
                    price: 0,
                    squareFeet: 0,
                    dateAvailable: " ",
                    floorPlan: ""
                )
            ]
            )
        
    ]
}

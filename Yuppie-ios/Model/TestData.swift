//
//  TestData.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//

import UIKit


import UIKit


enum TestData {
    
    static let cards = [
        Card(balance: 395,
         cardNumber: "EnV Chicago",
         cardHolderName: "161 W Kinzie St, Chicago, IL 60654",
         serviceLogo: UIImage(named: "bozuttologo")!,
         color: UIImage(named: "bozutto3")!),
        
    Card(balance: 2000,
         cardNumber: "Essex on Park",
         cardHolderName: "808 S. Michigan Ave. Chicago, IL 60605",
         serviceLogo: UIImage(named: "bozuttologo")!,
         color: UIImage(named: "bozutto2")!),
    
    Card(balance: 4500,
         cardNumber: "Atwater Apartments",
         cardHolderName: "355 East Ohio Street Chicago, IL 60611",
         serviceLogo: UIImage(named: "bozuttologo")!,
         color: UIImage(named: "bozutto1")!)
    ]
    static let buildings = [
        Building(
            id: "395",
            name: "The Atellier",
            images: ["bozutto1", "bozutto2"],
            description: "Live life in luxary in one of the best apartment buildings in the city. 60 story Hudson Yards skyscraper just minutes away fro the mid-town.",
            address: "635 W 42nd Street, New York, NY, 10036",
            amenities: ["Pool", "Gym"],
            units: [
                Unit(
                    id: "1",
                    name: "40H",
                    bedrooms: "2",
                    bathrooms: "2",
                    price: "3000",
                    sqft: "2000"
                )
            ]
            ),
        Building(
            id: "396",
            name: "The Atellie",
            images: ["bozutto1", "bozutto2"],
            description: "Live life in luxary in one of the best apartment buildings in the city. 60 story Hudson Yards skyscraper just minutes away fro the mid-town.",
            address: "635 W 42nd Street, New York, NY, 10036",
            amenities: ["Pool", "Gym"],
            units: [
                Unit(
                    id: "1",
                    name: "40H",
                    bedrooms: "2",
                    bathrooms: "2",
                    price: "3000",
                    sqft: "2000"
                )
            ]
            ),
        Building(
            id: "397",
            name: "The Atelli",
            images: ["bozutto1", "bozutto2"],
            description: "Live life in luxary in one of the best apartment buildings in the city. 60 story Hudson Yards skyscraper just minutes away fro the mid-town.",
            address: "635 W 42nd Street, New York, NY, 10036",
            amenities: ["Pool", "Gym"],
            units: [
                Unit(
                    id: "1",
                    name: "40H",
                    bedrooms: "2",
                    bathrooms: "2",
                    price: "3000",
                    sqft: "2000"
                )
            ]
            ),
        
    ]
}

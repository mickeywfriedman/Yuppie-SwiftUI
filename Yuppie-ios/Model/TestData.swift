//
//  TestData.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//

import UIKit


enum TestData {
    
    
    static let buildings = [
        Building(
            id: "395",
            name: "The Atellier",
            images: ["atelier", "atelier1", "atelier2", "atelier3"],
            description: "Live life in luxary in one of the best apartment buildings in the city. 60 story Hudson Yards skyscraper just minutes away fro the mid-town.",
            address: "635 W 42nd Street",
            amenities: ["Pool", "Gym"],
            latitude: 41.87148975,
            longitude: -87.6247186,
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
            name: "15 Bank Apartments",
            images: ["bozutto1", "bozutto2"],
            description: "Live life in luxary in one of the best apartment buildings in the city. 60 story Hudson Yards skyscraper just minutes away fro the mid-town.",
            address: "15 Bank Street Suite 100",
            amenities: ["Pool", "Gym"],
            latitude: 41.87148975,
            longitude: -87.6247186,
            
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
            address: "635 W 42nd Street",
            amenities: ["Pool", "Gym"],
            latitude: 41.87148975,
            longitude: -87.6247186, 
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

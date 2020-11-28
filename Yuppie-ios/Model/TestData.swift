//
//  TestData.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//

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
    
}

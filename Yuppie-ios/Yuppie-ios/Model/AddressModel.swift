//
//  AddressModel.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 14/10/1399 AP.
//


import SwiftUI

class AddressModel: ObservableObject {

    @Published var universities = [
        
        University( id: "5feb477f79adebb6cf4ea243", name: "The Atellier (15 Bank Street)", logo:""),
        University(id: "5feb477f79adebb6cf4ea243", name: "The Atellie (15 Bank Street)", logo: "")
      
    ]
    
    
    @Published var isConnected = false
    @Published var showSheet = false
    
    @Published var currentUniversity = University(id: "5feb477f79adebb6cf4ea243", name: "The Atellier", logo: "us")
}

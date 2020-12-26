//
//  UniversityModel.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 03/10/1399 AP.
//

import SwiftUI

class UniversityModel: ObservableObject {

    @Published var universities = [
        
        University(name: "University of Chicago", flag: "us"),
        University(name: "University of Illinois", flag: "in"),
        University(name: "Loyola University", flag: "uk"),
      
    ]
    
    
    @Published var isConnected = false
    @Published var showSheet = false
    
    @Published var currentUniversity = University(name: "University of Chicago", flag: "us")
}

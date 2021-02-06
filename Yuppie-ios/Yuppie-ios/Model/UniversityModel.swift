//
//  UniversityModel.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 03/10/1399 AP.
//

import SwiftUI

class UniversityModel: ObservableObject {

    @Published var universities = [
        
        University( id: "5feb477f79adebb6cf4ea243", name: "University of Chicago", logo: "us")
      
    ]
    
    
    @Published var isConnected = false
    @Published var showSheet = false
    
    @Published var currentUniversity = University(id: "5feb477f79adebb6cf4ea243", name: "University of Chicago", logo: "us")
}

//
//  CardMenu.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//

import SwiftUI


/// Hardcoded simple three buttons card actions menu
struct CardMenu : View {
    
    let size: CGFloat
    
    var body: some View {
        VStack(spacing: 0){
            Image(systemName: "message")
                .font(.system(size: 30.0))
                .foregroundColor(Color.white)
                .frame(width: size, height: size)
            
            Image(systemName: "building")
                .font(.system(size: 30.0))
                .foregroundColor(Color.white)
                .frame(width: size, height: size)
            
            Image(systemName: "pencil.and.ellipsis.rectangle")
                .font(.system(size: 30.0))
                .foregroundColor(Color.white)
                .frame(width: size, height: size)
            
           
        }
        .background(Color(#colorLiteral(red: 0.1803921569, green: 0.2, blue: 0.2352941176, alpha: 1)))
        .cornerRadius(8)
    }
    
}

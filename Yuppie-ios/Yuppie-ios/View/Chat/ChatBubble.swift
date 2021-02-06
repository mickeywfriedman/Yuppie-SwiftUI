//
//  ChatBubble.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 09/11/1399 AP.
//

import SwiftUI

struct ChatBubble: Shape {

    var myMsg : Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        
        return Path(path.cgPath)
    }
}


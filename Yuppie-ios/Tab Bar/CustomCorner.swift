//
//  CustomCorner.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 02/10/1399 AP.
//

import SwiftUI

struct CustomCorner: Shape {

    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: -35, height: -35))
        
        return Path(path.cgPath)
    }
}


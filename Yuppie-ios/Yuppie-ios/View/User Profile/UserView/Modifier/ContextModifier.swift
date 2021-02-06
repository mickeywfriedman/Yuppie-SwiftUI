//
//  ContextModifier.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/11/1399 AP.
//

import SwiftUI

struct ContextModifier: ViewModifier {

    // ContextMenu Modifier...
    var card: UserCard
    
    func body(content: Content) -> some View {
        
        content
            .contextMenu(menuItems: {

                Text("By \(card.author)")
            })
            .contentShape(RoundedRectangle(cornerRadius: 5))
    }
}

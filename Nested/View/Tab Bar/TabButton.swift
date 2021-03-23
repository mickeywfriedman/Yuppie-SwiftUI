//
//  TabButton.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 02/10/1399 AP.
//

import SwiftUI

struct TabButton: View {
    var title: String
    var image: String
    
    @Binding var selected : String
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring()){selected = title}
        }) {
            
            HStack(spacing: 10){
                
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
                
                if selected == title{
                    
                    Text(title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.custom("Futura Light", size: 18))
                }
            }
            .padding(.vertical,10)
            .padding(.horizontal)
            .background(Color.blue.opacity(selected == title ? 0.08 : 0))
            .clipShape(Capsule())
        }
    }
}


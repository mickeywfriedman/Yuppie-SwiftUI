//
//  CardViewOnboarding.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 04/10/1399 AP.
//

import SwiftUI

struct CardViewOnboarding: View {
    var University : University
    var subTitle: String
    
    var body: some View {
        
        HStack(spacing: 15){
            
            Image(University.logo)
                .resizable()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 3, content: {
                
                Text(University.name)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                
                if subTitle != ""{
                    
                    Text(subTitle)
                        .foregroundColor(.gray)
                }
            })
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 24))
                .foregroundColor(.black)
        }
        .padding(.leading,8)
        .padding(.trailing)
        .padding(.vertical)
    }
}


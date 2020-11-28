//
//  CardView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//

import SwiftUI


/// Credit card view
struct CardView: View {
    
    // MARK: - Model
    
    let card: Card
    
    
    // MARK: - Animatable
    
    var flarePosition: UnitPoint = UnitPoint(x: 0.3, y: 0.2)
    var animatableData: UnitPoint {
        get { return flarePosition }
        set { flarePosition = newValue }
    }
    
    
    // MARK: - Private
    
    private let currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = "$"
        currencyFormatter.locale = Locale(identifier: "en")
        
        return currencyFormatter
    }()
    
    
    // MARK: - Body
    
    var body: some View {
        let gradient = RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9607843161, green: 0.9607843161, blue: 0.9607843161, alpha: 0.1)), Color(#colorLiteral(red: 0.2784313725, green: 0.3019607843, blue: 0.3294117647, alpha: 0))]),
                                      center: flarePosition,
                                      startRadius: 50,
                                      endRadius: 300)
        
        return ZStack {
            Image(uiImage: card.color).cornerRadius(16)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("1, 2, 3 br")
                        .foregroundColor(Color.white)
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Text(currencyFormatter.string(from: NSNumber(value: card.balance)) ?? "")
                        .foregroundColor(Color.white)
                        .fontWeight(.heavy)
                        .font(.custom("Futura", size: 28))
                    
                    Spacer()
                    
                    Image("chip")
                    
                    Text(card.cardNumber)
                        .foregroundColor(Color.white)
                        .font(.custom("Futura", size: 22))
                        .fontWeight(.bold)
                    
                    Text(card.cardHolderName)
                        .foregroundColor(Color.white)
                        .font(.custom("Futura", size: 14))
                    
                }
                Spacer()
            }
            .padding(18)
            
            VStack {
                HStack {
                    Spacer()
                    Image(uiImage: card.serviceLogo)
                }
                Spacer()
            }
            .padding(18)
            
            gradient
                .cornerRadius(31)
        }
        .aspectRatio(1.586, contentMode: .fit)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: TestData.cards.first!)
            .environment(\.sizeCategory, .small)
        .padding(32)
    }
}

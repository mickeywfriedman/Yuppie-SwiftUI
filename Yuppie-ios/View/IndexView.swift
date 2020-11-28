//
//  IndexView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//


import SwiftUI
import Mapbox


/// Selected index view
struct IndexView: View {
    
    @State var annotations: [MGLPointAnnotation] = [
        MGLPointAnnotation(title: "Mapbox", coordinate: .init(latitude: 37.791434, longitude: -122.396267))
    ]
    
    
    
    private var count: Int = 0
    
    
    
    // MARK: - Animatable
    
    var selectedIndex: Int = 0
    var animatableData: Int {
        get { return selectedIndex }
        set { selectedIndex = newValue }
    }
    
    
    // MARK: - Body
    
    var body: some View {
        
       
        
        let size: CGFloat = 10
        let selectedScaleFactor: CGFloat = 2.5
        
        return
            MapView(annotations: $annotations).centerCoordinate(.init(latitude: 37.791293, longitude: -122.396324)).zoomLevel(15)
            
       
    }
    
    
    // MARK: - Modifiers
    
    func select(at index: Int, in count: Int) -> Self {
        var indexView = self
        indexView.selectedIndex = index
        indexView.count = count
        return indexView
    }
    
}


private struct IndexViewPreview: View {
    
    let count = 4
    
    @State var index = 0
    
    var body: some View {
        
        
        ZStack(alignment: .leading) {
            Color(#colorLiteral(red: 0.1529411765, green: 0.1725490196, blue: 0.2078431373, alpha: 1)).edgesIgnoringSafeArea(.all)
            VStack {
                
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.index = (self.index + self.count - 1) % self.count
                        }
                    }) {
                        Text("PREV")
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)))
                    .cornerRadius(4)
                    Button(action: {
                        withAnimation {
                            self.index = (self.index + 1) % self.count
                        }
                    }) {
                        Text("NEXT")
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)))
                    .cornerRadius(4)
                    
                    Spacer()
                }
                .padding()
                
                Text("\(index)")
                    .foregroundColor(Color.white)
                    .font(.title)
                    .padding()
                Spacer()
            }
            
            IndexView() .select(at: index, in: count)
        }
    }
}


struct IndexViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        IndexViewPreview()
    }
}


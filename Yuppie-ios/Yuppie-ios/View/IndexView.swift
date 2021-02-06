//
//  IndexView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/28/20.
//


import SwiftUI
import Mapbox


/// Selected index view

struct HotAnnotation{
    var body: some View{
        ZStack{
            Circle().fill(Color.red.opacity(0.25)).frame(width:350, height:350)
        }
    }
}
struct IndexView: View {
    @Binding var buildings : [Building]
    
    @State var annotations: [MGLPointAnnotation] = [
        MGLPointAnnotation(title: "$13", coordinate: .init(latitude: 40.761360, longitude: -73.999222))
        ,
        
        MGLPointAnnotation(title: "$2000", coordinate: .init(latitude: 40.737140, longitude: -73.998140)),
        

       
    ]
    
    
    
    var count: Int = 0
    
    
    
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
            
            ZStack{
               
            MapView(annotations: $annotations).centerCoordinate(.init(latitude: 40.746360, longitude: -73.999222)).zoomLevel(13)
                Image("topgradient")
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: UIScreen.main.bounds.width)
                    .offset(y: -150)
           }
    }
    
    
    // MARK: - Modifiers
    
    func select(at index: Int, in count: Int) -> Self {
        var indexView = self
        indexView.selectedIndex = index
        indexView.count = count
        return indexView
        
    }
    
}



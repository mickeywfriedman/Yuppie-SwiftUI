//
//  testScroll.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI

struct testScroll: View {
    var buildings : [Building]
    @State var minBedrooms = 0
    @State var minBathrooms = 0
    @State var maxPrice = 10000.0
    @State var isFavorite = true
    @State private var showFilters = false
    func filter(units: [Unit], maxPrice: Double, minBathrooms: Int, minBedrooms: Int) -> Bool{
        for unit in units{
            if (unit.bedrooms >= minBedrooms && unit.bathrooms >= minBathrooms && unit.price <= maxPrice){
                return true
            }
        }
        return false
    }
    func filterBuildings (buildings: [Building], maxBedrooms: Int, maxBathrooms: Int, maxPrice: Double) -> [Building] {
        var filteredBuildings = [Building]()
        for building in buildings{
            if (filter(units: building.units, maxPrice: maxPrice, minBathrooms: minBathrooms, minBedrooms: minBedrooms)){
                filteredBuildings.append(building)
            }
        }
        if (filteredBuildings.count==0){
            return [Building(
                name: "No Matches",
                images: ["http://18.218.78.71:8080/images/5fdbefceae921a507c9785de","http://18.218.78.71:8080/images/5fdbefceae921a507c9785dd"],
                description: "Live life in luxary in one of the best apartment buildings in the city. 60 story Hudson Yards skyscraper just minutes away fro the mid-town.",
                address: Address(
                    streetAddress: "15 Bank Street",
                    city: "New York City",
                    state: "NY",
                    zipCode: 10036
                ),
                amenities: ["Pool", "Gym"],
                propertyManager: propertyManager(
                    email: "propertyManager1@gmail.com",
                    id: "5fd002a21ed3e413beb713d4"
                ),
                units: [
                    Unit(
                        number: "40H",
                        bedrooms: 2,
                        bathrooms: 2,
                        price: 3000,
                        squareFeet: 2000,
                        dateAvailable: "Today",
                        floorPlan: "http://18.218.78.71:8080/images/5fdb99bcae921a507c9785cc"
                    )
                ]
                )]
        }
        return filteredBuildings
    }
    var body: some View {
        ZStack{
            VStack {
                Button(action: {
                    self.showFilters.toggle()
                            }) {
                    Image(systemName:"slider.horizontal.3").foregroundColor(.black)
                }.offset(x:150, y:50)
                
                .sheet(isPresented: $showFilters) {
                    FiltersView(showFilters: self.$showFilters, Bedroom : self.$minBedrooms, Bathroom: self.$minBathrooms, MaxPrice : self.$maxPrice)
                }
                Scroll(buildings:buildings.filter({filter(units: $0.units, maxPrice: maxPrice, minBathrooms: minBathrooms, minBedrooms: minBedrooms)}), minBedrooms: minBedrooms, minBathrooms: minBathrooms)
                    .offset(y:400)
                
            }.edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

struct Scroll: View {
    @GestureState private var translation: CGFloat = 0
    @State var index: Int = 0
    var buildings: [Building]
    var minBedrooms: Int
    var minBathrooms: Int
    var body: some View {
        GeometryReader { geometry in
            HStack (spacing: 0){
                ForEach(buildings, id:\.name) {building in
                    CardView(building:building, minBedrooms: minBedrooms, minBathrooms: minBathrooms)
                        .padding(.horizontal, 20)
                }
            }
           .frame(width: geometry.size.width, alignment: .leading)
           .offset(x: -CGFloat(self.index) * geometry.size.width)
           .animation(.interactiveSpring())
           .gesture(
              DragGesture()
                 .updating(self.$translation) { gestureValue, gestureState, _ in
                           gestureState = gestureValue.translation.width
                  }
                 .onEnded { value in
                    var weakGesture : CGFloat = 0
                         if value.translation.width < 0 {
                            weakGesture = -100
                         } else {
                            weakGesture = 100
                         }
                    let offset = (value.translation.width + weakGesture) / geometry.size.width
                            let newIndex = (CGFloat(self.index) - offset).rounded()
                            self.index = min(max(Int(newIndex), 0), self.buildings.count - 1)
                 }
           )
        }
        
    }
}


struct testScroll_Previews: PreviewProvider {
    static var previews: some View {
        testScroll(buildings:TestData.buildings)
    }
}

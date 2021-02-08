//
//  testScroll.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI
import Mapbox
struct testScroll: View {
    @Binding var token: String
    @Binding var user_id: String
    var buildings : [Building]
    @Binding var user : User
    @State var isFavorite = true
    @State private var showFilters = false
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    func filter(units: [Unit]) -> Bool{
        for unit in units{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date_avail = dateFormatter.date(from: unit.dateAvailable)
            if (unit.bedrooms >= user.preferences.bedrooms && unit.bathrooms >= user.preferences.bathrooms && Int(unit.price) <= Int(user.preferences.price) && date_avail ?? Date() < dateFormat(string: user.preferences.latestMoveInDate)){
                return true
            }
        }
        return false
    }
    func filterBuildings (buildings: [Building]) -> [Building] {
        var filteredBuildings = [Building]()
        for building in buildings{
            if (filter(units: building.units)){
                filteredBuildings.append(building)
            }
        }
        if (filteredBuildings.count==0){
            return [Building(
                id: "1",
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
                tenants: [tenant(
                    profilePicture: "http://18.218.78.71:8080/images/5fdbefceae921a507c9785de",
                    id: "5fd002a21ed3e413beb713d4",
                    firstName: "Leon"
                )],
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
                    FiltersView(showFilters: self.$showFilters, token: $token, user: $user, user_id: $user_id, minDate: dateFormat(string: user.preferences.earliestMoveInDate), maxDate: dateFormat(string: user.preferences.latestMoveInDate))
                }
                Scroll(user: $user, token: $token, user_id: $user_id, buildings:buildings.filter({filter(units: $0.units)}))
                    .offset(y:400)
                
            }.edgesIgnoringSafeArea([.top, .bottom])
        }
    }
}

struct Scroll: View {
    @GestureState private var translation: CGFloat = 0
    @State var index: Int = 0
    @State var expand = false
    @Binding var user : User
    @Binding var token: String
    @Binding var user_id: String
    var buildings: [Building]
    @State var annotations: [MGLPointAnnotation] = [
        MGLPointAnnotation(title: "Mapbox", coordinate: .init(latitude: 37.791439, longitude: -122.396267))
        ,
        
        MGLPointAnnotation(title: "Mapbox", coordinate: .init(latitude: 37.792134, longitude: -122.394217)),
        
        MGLPointAnnotation(title: "Mapbox", coordinate: .init(latitude: 37.793134, longitude: -122.393217)),
        
       
    ]
    
    var body: some View {
        GeometryReader { geometry in
            HStack (spacing: 0){
                ForEach(buildings, id:\.name) {building in
                    VStack{
                        Chats(token: $token, user_id: $user_id, building:building, expand: self.$expand)
                            .offset(y:-450)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        
                        CardView(token: $token, user: $user, user_id: $user_id, building:building)
                            .padding(.horizontal, 20)
                       // .padding(.horizontal, 20)
                        .offset(y:-490)
                        
//
//                        let currentCamera = mapView.camera
//                                    let camera = MGLMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: 40.7411, longitude: -73.9897), acrossDistance: currentCamera.viewingDistance, pitch: currentCamera.pitch, heading: currentCamera.heading)
//                                    mapView.fly(to: camera, withDuration: 4, peakAltitude: 3000, completionHandler: nil)
                      
                                                // Animate the camera movement over 5 seconds.

                        
                        
                        
                        
                    
                    }
                    
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



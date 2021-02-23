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
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    func filter(units: [Unit], buildingAmenities: [String]) -> Bool{
        for unit in units{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date_avail = dateFormatter.date(from: unit.dateAvailable)
            if (unit.bedrooms >= user.preferences.bedrooms && unit.bathrooms-1 >= user.preferences.bathrooms && Int(unit.price) <= Int(user.preferences.price) && date_avail ?? Date() < dateFormat(string: user.preferences.latestMoveInDate)){
                for amenity in user.preferences.amenities {
                    if (!buildingAmenities.contains(amenity)){
                        return false
                    }
                }
                return true
            }
        }
        return false
    }
    let newCam = MGLMapCamera()
    var gradient = [Color("Color-3"),Color("gradient2"),Color("gradient3"),Color("gradient4")]

    var body: some View {
        ZStack{
            if buildings.filter({filter(units: $0.units, buildingAmenities:$0.amenities)}).count > 0 {
                VStack {
                    Scroll(user: $user, token: $token, user_id: $user_id, buildings:buildings.filter({filter(units: $0.units, buildingAmenities:$0.amenities)}))
                                        .offset(y:400)
                    
                }.edgesIgnoringSafeArea([.top, .bottom])
            } else {
                ZStack{
                    LinearGradient(gradient: .init(colors: gradient), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    VStack{
                        Text("No buildings match your preferences")
                        Image("buildings")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    }
                }
            }
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
    func reset() -> Void {
        index = 0
    }
    
    @State var offset : CGFloat = UIScreen.main.bounds.height
    var buildings: [Building]
    @State var annotations: [MGLPointAnnotation] = [
        MGLPointAnnotation(title: "$13", coordinate: .init(latitude: 40.761295318603516, longitude: -73.99922180175781))
        ,
        
        MGLPointAnnotation(title: "$2000", coordinate: .init(latitude: 40.74340057373047, longitude: -74.0054702758789)),
        
        MGLPointAnnotation(title: "$2000", coordinate: .init(latitude: 40.77073287963867, longitude: -73.99181365966797)),
        
        MGLPointAnnotation(title: "$2000", coordinate: .init(latitude: 40.75188064575195, longitude: -74.00379180908203)),

       
    ]
    
    let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/cephalopod004/ckkqhhfrt01hw17qlfsq1gwt4"))
    

    
//    func coordinate_lat(forAddress address: (String) -> CLLocationCoordinate2D) {
//        var geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(address) { placemarks, error in
//            let placemark = placemarks?.first
//            let lat = placemark!.location!.coordinate.latitude
//            let lon = placemark!.location!.coordinate.longitude
//            print("Lat: \(lat), Lon: \(lon)")
//            return (CLLocationCoordinate2D(latitude: lat, longitude: lon))
//        }
//    }

    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
            let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> CLLocationCoordinate2D) {
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark!.location!.coordinate.latitude
            let lon = placemark!.location!.coordinate.longitude
            print("Lat: \(lat), Lon: \(lon)")
            greetAgain(latitude: lat, longitude: lon)
           
        }
    }
    
    func greetAgain(latitude: Double, longitude: Double) -> CLLocationCoordinate2D {
        return (CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
    }
    
    

    var body: some View {
        GeometryReader { geometry in
            HStack (spacing: 0){
                ForEach(buildings, id:\.name) {building in
                    ZStack{
                        MapView(annotations: $annotations, building: building).centerCoordinate((annotations[0].coordinate)).zoomLevel(15).offset(y:-450)
                        
                        Image("topgradient")
                                                       .resizable()
                                                       .aspectRatio(contentMode: .fit)                                   .aspectRatio(contentMode: .fit)
                            .offset(y:-710)
                      
                    VStack{
                        
                        HStack{
                        
                        Label(title: {
                        }) {Text("Chat with Current Residents")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                           
                        } .padding(.vertical,4)
                        .padding(.horizontal,10)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .opacity(0.7)
                        .offset(x: 15, y:-350)
                            
                            Button(action: {
                                self.offset = 0
                            }) {
                                
                                Label(title: {
                                   
                                    
                                }) {
                                    
                                    
                                                            Image(systemName: "gear")
                                                                .foregroundColor(Color.white)
                                                           
                                }
                                .padding(.vertical,8)
                                .padding(.horizontal,10)
                                .background(Color("Chat_color").opacity(0.5))
                                .clipShape(Capsule())
                            } .offset(x: 30, y:-350)
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                            Text("")
                            Chats(token: $token, user: $user, user_id: $user_id, building:building, expand: self.$expand)
                            }
                           
                        }.offset(y:-435)
                        
                        
                        CardView(token: $token, user: $user, user_id: $user_id, building:building)
                            .padding(.horizontal, 20)
                        .offset(y:-520)
                        
                    }
                    
                    }
                    
                }
                
            }
           .frame(width: geometry.size.width, alignment: .leading)
           .offset(x: -CGFloat(self.index) * geometry.size.width)
           .animation(.interactiveSpring())
            .onDisappear(perform: {
                reset()
            })
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

struct Navshape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        
        return Path(path.cgPath)
    }
}



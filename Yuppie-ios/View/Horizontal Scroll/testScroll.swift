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

class MapScroll: ObservableObject {
    @Published var ipAddress: String = ""

    func scroll_map(building: Building) {
        let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/cephalopod004/ckkqhhfrt01hw17qlfsq1gwt4"))
        let lat = Double(building.latitude) as! CLLocationDegrees
     let lon = Double(building.longitude) as! CLLocationDegrees
        let camera = MGLMapCamera(lookingAtCenter: (CLLocationCoordinate2D(latitude: lat, longitude: lon)),  fromDistance: 4500, pitch: 15, heading: 180)
        mapView.fly(to: camera, withDuration: 4,
        peakAltitude: 3000, completionHandler: nil)
    }
    
}

struct Scroll: View {
    @ObservedObject var mapScroll: MapScroll = MapScroll()
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
    
    let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: URL(string: "mapbox://styles/cephalopod004/ckkqhhfrt01hw17qlfsq1gwt4"))
    func scroll_map(building: Building) {
        let lat = Double(building.latitude) as! CLLocationDegrees
     let lon = Double(building.longitude) as! CLLocationDegrees
        let camera = MGLMapCamera(lookingAtCenter: (CLLocationCoordinate2D(latitude: lat, longitude: lon)),  fromDistance: 4500, pitch: 15, heading: 180)
        mapView.fly(to: camera, withDuration: 4,
        peakAltitude: 3000, completionHandler: nil)
    }
   
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
            updateAnnotations()
            let address_coord = coordinates() {
                (location) in
                guard let location = location else {
                    return
                }}
            
            //print(address_coord)
            
            
        }
      
        
        func coordinates(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
                        let lat = Double(45.7) as! CLLocationDegrees
                        let lon = Double(77.7) as! CLLocationDegrees
            print("Lat: \(lat), Lon: \(lon)")
            moveToCoordinate(mapView, to: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            return
        }
    
    private func moveToCoordinate(_ mapView: MGLMapView, to point: CLLocationCoordinate2D) {
        
        let camera = MGLMapCamera(lookingAtCenter: point,  fromDistance: 4500, pitch: 15, heading: 180)
        mapView.fly(to: camera, withDuration: 4,
        peakAltitude: 3000, completionHandler: nil)
//        let camera = MGLMapCamera(lookingAtCenter: point, fromDistance: 4500, pitch: 15, heading: 180)
//        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    }
    
    private func updateAnnotations() {
        if let currentAnnotations = mapView.annotations {
            mapView.removeAnnotations(currentAnnotations)
        }
        mapView.addAnnotations(annotations)
    }
    
    class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
    super.layoutSubviews()
     
    // Use CALayer’s corner radius to turn this view into a circle.
    layer.cornerRadius = bounds.width / 2
    layer.borderWidth = 6
    layer.borderColor = UIColor.white.cgColor
        layer.addPulse { builder in
            builder.repeatCount = 10
        }
    }
     
    override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
     
    // Animate the border width in/out, creating an iris effect.
    let animation = CABasicAnimation(keyPath: "borderWidth")
    animation.duration = 0.1
    layer.borderWidth = selected ? bounds.width / 10 : 2
    layer.add(animation, forKey: "borderWidth")
    }
    
    
    
}
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
        }
        
        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            
            let coordinates = [
                CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
                CLLocationCoordinate2D(latitude: 37.791591, longitude: -122.396566),
                CLLocationCoordinate2D(latitude: 37.791147, longitude: -122.396009),
                CLLocationCoordinate2D(latitude: 37.790883, longitude: -122.396349),
                CLLocationCoordinate2D(latitude: 37.791329, longitude: -122.396906),
            ]
            
            let buildingFeature = MGLPolygonFeature(coordinates: coordinates, count: 5)
            let shapeSource = MGLShapeSource(identifier: "buildingSource", features: [buildingFeature], options: nil)
            mapView.style?.addSource(shapeSource)
            
          

        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            // This example is only concerned with point annotations.
            guard annotation is MGLPointAnnotation else {
            return nil
            }
             
            // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
            let reuseIdentifier = "\(annotation.coordinate.longitude)"
             
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
             
            // If there’s no reusable annotation view available, initialize a new one.
            if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
                annotationView!.backgroundColor = UIColor(red: 0.7882, green: 0.498, blue: 0.8784, alpha: 1.0)
            }
             
            return annotationView
        }
         
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            return true
        }
        
        func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4500, pitch: 15, heading: 180)
        mapView.fly(to: camera, withDuration: 4,
                    peakAltitude: 300, completionHandler: nil)
            mapView.zoomLevel = 15
        }
        
        
        
    }
    
    

    var body: some View {
        GeometryReader { geometry in
            HStack (spacing: 0){
                ForEach(buildings, id:\.name) {building in
                    ZStack{ Image("topgradient")
                           .resizable()
                           .aspectRatio(contentMode: .fit)
                            .aspectRatio(contentMode: .fit)
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
                                }) { Image(systemName: "gear")
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
                            
                    }.gesture(
                        
                        
                        DragGesture()
                           .updating(self.$translation) { gestureValue, gestureState, _ in
                                     gestureState = gestureValue.translation.width
                            updateAnnotations()
                            scroll_map(building: building)
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
           .frame(width: geometry.size.width, alignment: .leading)
           .offset(x: -CGFloat(self.index) * geometry.size.width)
           .animation(.interactiveSpring())
            .onDisappear(perform: {
                reset()
            })
           
        }
        
    }
}

struct Navshape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        
        return Path(path.cgPath)
    }
}



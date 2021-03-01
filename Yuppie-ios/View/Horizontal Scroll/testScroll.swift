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
    func filteredBuildings() -> [Building]{
        return buildings.filter({filter(units: $0.units, buildingAmenities:$0.amenities)})
    }
    var gradient = [Color("Color-3"),Color("gradient2"),Color("gradient3"),Color("gradient4")]

    var body: some View {
        ZStack{
            if filteredBuildings().count > 0 {
                VStack {
                    Scroll(user: $user, token: $token, user_id: $user_id, buildings:buildings)
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
    @State var card = ""
    @State var showCard = false
    @State var index: Int = 0
    @State var expand = false
    @Binding var user : User
    @Binding var token: String
    @Binding var user_id: String
    @State var minDate = Date()
    @State var maxDate = Date(timeInterval: 14*86400, since: Date())
    @State var tenant_id = ""
    @State var tenant_prof = ""
    @State var tenant_name = ""
    @State var showChatUI = false
    @State var search = ""
    @State var showInbox = false
    @State var first = true
    func getDocumentsDirectory1() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
<<<<<<< HEAD
   

    
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
=======
    func writeTenant(){
        let text = ""
        
        let filename = getDocumentsDirectory1().appendingPathComponent("index.txt")
        do {
            try text.write(to: filename, atomically: false, encoding: .utf8)
            try (self.tenant_id+self.user_id+("token_id:")+self.token ).write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
>>>>>>> 38ae6ec411b51e7608b56baccf3234f49c555219
        }
        mapView.addAnnotations(annotations)
    }
<<<<<<< HEAD
    
    class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
    super.layoutSubviews()
     
    // Use CALayer’s corner radius to turn this view into a circle.
    layer.cornerRadius = bounds.width / 2
    layer.borderWidth = 6
    layer.borderColor = UIColor.white.cgColor
        layer.addPulse { builder in
            builder.repeatCount = 10
=======
    func reset() -> Void {
        index = 0
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
>>>>>>> 38ae6ec411b51e7608b56baccf3234f49c555219
        }
        return false
    }
<<<<<<< HEAD
     
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
        
        
        
=======
    func filteredBuildings() -> [Building]{
        return buildings.filter({filter(units: $0.units, buildingAmenities:$0.amenities)})
    }
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    @State var offset : CGFloat = UIScreen.main.bounds.height
    @State var buildings: [Building]
    func annotations () -> [MGLPointAnnotation]{
        var result = [MGLPointAnnotation(coordinate: .init(latitude: 40.761295318603516, longitude: -73.99922180175781))]
        for building in buildings {
            result.append(MGLPointAnnotation(coordinate: .init(latitude: Double(building.latitude), longitude: Double(building.longitude))))
        }
        result.removeFirst(1)
        return result
>>>>>>> 38ae6ec411b51e7608b56baccf3234f49c555219
    }
    var body: some View {
        GeometryReader { geometry in
<<<<<<< HEAD
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
=======
            ZStack{
                MapView(annotations: annotations(), buildings: $buildings, index: $index, user: $user, first: $first).centerCoordinate(CLLocationCoordinate2D(latitude: Double(buildings[index].latitude), longitude: Double(buildings[index].longitude))).zoomLevel(15).offset(y:-450).onDisappear(perform: {
                    reset()
                })
                VStack{
                    HStack{
                        Text("Chat with Current Residents")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .padding(.vertical,4)
>>>>>>> 38ae6ec411b51e7608b56baccf3234f49c555219
                        .padding(.horizontal,10)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .opacity(0.7)
<<<<<<< HEAD
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
=======
                        Button(action: {
                            self.card = "filter"
                            self.showCard = true
                        }) {
                            Label(title: {
                            }) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(Color.white)
                            }
                            .padding(.vertical,8)
                            .padding(.horizontal,10)
                            .background(Color("Chat_color").opacity(0.5))
                            .clipShape(Capsule())
                        }
                    }
                    HStack (spacing: 0){
                        ForEach(filteredBuildings(), id:\.name) {building in
                            VStack(spacing: 0){
                                
                                ZStack{
                                    NavigationLink(destination: ChatUI(token: $token, user_id: $user_id, tenant_id: $tenant_id, tenant_prof: $tenant_prof, tenant_name: $tenant_name)){
                                        
                                        Text("")
                                    }
                                    
                                    NavigationLink(destination: Inbox(token: $token, user_id: $user_id, user: $user), isActive: self.$showInbox) {
                                        
                                        Text("")
                                    }
                                
                                VStack{
                                    
                                    
                                    if true{
                                        
                                        HStack{
                                           
                                            
                                            Button(action: {
                                                
                                            }) {
                                                Image("menu")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(Color.black.opacity(0.4))
                                            }

                                        }
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            
                                            HStack(spacing: 18){
                                                
                                                VStack{
                                                    
                                                    ZStack{
                                                
                                                Button(action: {
                                                    self.showCard.toggle()
                                                    self.card = "inbox"
                                                    
                                                }) { Image(systemName: "message")
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                        .foregroundColor(Color.white)
                                                    .padding(18)
                                                }.background(Color("blueshadow").opacity(0.5))
                                                .clipShape(Circle())
                                                    
                                                    Circle()
                                                    .trim(from: 0, to: 1)
                                                        .stroke(AngularGradient(gradient: .init(colors: [.purple,.blue,.purple]), center: .center), style: StrokeStyle(lineWidth: 4, dash: [false ? 7 : 0]))
                                                    .frame(width: 68, height: 68)
                                                    .rotationEffect(.init(degrees: true ? 360 : 0))
                                                        .padding(3)
                                                        
                                                    }
                                                
                                                    Label(title: {
                                                    }) {Text("Inbox")
                                                        .foregroundColor(Color.black)
                                                        .lineLimit(1)
                                                        
                                                    } .padding(.vertical,4)
                                                    .padding(.horizontal,10)
                                                    .background(Color.white)
                                                    .clipShape(Capsule())
                                                    .opacity(0.8)
                                                    
                                            }
                                                ForEach(building.tenants,id: \.self){tenant in
                                                    
                                                    Button(action: {
                                                        self.showCard = true
                                                        self.card = "chat"
                                                        tenant_id = String(tenant.id)
                                                        tenant_prof = String(tenant.profilePicture)
                                                        tenant_name = String(tenant.firstName)
                                                        writeTenant()
                                                    }) {
                                                        VStack(spacing: 8){
                                                        ZStack{
                                                        URLImage(url: tenant.profilePicture)
                                                        .frame(width: 60, height: 60)
                                                            .cornerRadius(30)
                                                            .padding(.bottom, 10)
                                                            .padding(.top, 10)
                                                        Circle()
                                                        .trim(from: 0, to: 1)
                                                            .stroke(AngularGradient(gradient: .init(colors: [.purple,.orange,.purple]), center: .center), style: StrokeStyle(lineWidth: 4, dash: [showChatUI ? 3 : 0]))
                                                        .frame(width: 68, height: 68)
                                                        .rotationEffect(.init(degrees: showChatUI ? 360 : 0))
                                                            .padding(3)
                                                        }
                                                            
                                                            Label(title: {
                                                            }) {Text(tenant.firstName)
                                                                .foregroundColor(Color.black)
                                                                .lineLimit(1)
                                                            } .padding(.vertical,4)
                                                            .padding(.horizontal,10)
                                                            .background(Color.white)
                                                            .clipShape(Capsule())
                                                            .opacity(0.8)
                                                            .offset(y: -5)
                                                        }
                                                        }
                                                }
                                            }
                                        }
                                    }
                                }.padding()
                                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                                .background(Color.clear)
                                .clipShape(shape())
                                .animation(.default)
                                
                            }.zIndex(0)
                                
                                Centerview(expand: self.$expand).offset(y: -1250)
                            }.frame(minWidth:(UIScreen.main.bounds.width-40), maxWidth: .infinity)
                                .padding(.top, -85).padding(.horizontal, 20)
                            }
                        }
                   .frame(width: geometry.size.width, alignment: .leading)
                    .offset(x: -CGFloat(self.index) * geometry.size.width)
                   .animation(.interactiveSpring())
>>>>>>> 38ae6ec411b51e7608b56baccf3234f49c555219
                    
                }.offset(y: -350)
            HStack (spacing: 0){
                ForEach(filteredBuildings(), id:\.name) {building in
                        CardView(token: $token, user: $user, user_id: $user_id, building:building, showCard: $showCard, card: $card)
                            .padding(.horizontal, 20)
                    }
                }
           .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.index) * geometry.size.width, y: -200)
           .animation(.interactiveSpring())
<<<<<<< HEAD
            .onDisappear(perform: {
                reset()
            })
           
=======
            
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
                            self.index = min(max(Int(newIndex), 0), filteredBuildings().count - 1)
                            self.first = false
                 }
           )
        }.sheet(isPresented: $showCard) {
            sheets(card: $card, user: $user, buildings: filteredBuildings(), user_id: $user_id, token:$token, index: $index, tenant_id : $tenant_id, tenant_prof: $tenant_prof, tenant_name:$tenant_name)
        }
>>>>>>> 38ae6ec411b51e7608b56baccf3234f49c555219
        }
}
}




//
//  BuildingView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI
import MapKit

struct BuildingImages: View{
    func addFavorite() -> Void {
        self.user.favorites.append(building.id)
        guard let favorites_url = URL(string: "http://18.218.78.71:8080/users/\(user_id)/favorites/\(building.id)") else {
                print("Your API end point is Invalid")
                return
            }
            var favorites_request = URLRequest(url: favorites_url)
            favorites_request.httpMethod = "POST"
            favorites_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: favorites_request) { data, response, error in
                return
            }.resume()
    }
    func deleteFavorite() -> Void {
        self.user.favorites = self.user.favorites.filter { $0 != building.id }
        guard let delete_url = URL(string: "http://18.218.78.71:8080/users/\(user_id)/favorites/\(building.id)") else {
                print("Your API end point is Invalid")
                return
            }
            var delete_request = URLRequest(url: delete_url)
            delete_request.httpMethod = "DELETE"
            delete_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: delete_request) { data, response, error in
                return
            }.resume()
    }
    func toggleFavorite() -> Void {
        if (user.favorites.contains(building.id)) {
            deleteFavorite()
        } else{
            addFavorite()
        }
    }
    @Binding var token: String
    @Binding var user : User
    @Binding var user_id: String
    @State var isFavorite = true
    @State var showForm = false
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    @State var index: Int = 0
    @State var expand = false
    var building: Building
    var body: some View{
        ZStack{
        ImageSlider(images: building.images, isFavorite: $isFavorite)
            .frame(height: 250)
            .clipShape(CustomShape(corner: .bottomLeft, radii: self.height > 800 ? 65: 60))
        Button(action: {
                toggleFavorite()
            }) {
                if (user.favorites.contains(building.id)) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.yellow)
                    } else {
                        Image(systemName: "heart")
                            .foregroundColor(Color.gray)
                    }
            }.offset(x: (-1*UIScreen.main.bounds.width/2)+25, y: -100)
        HStack{
            Spacer()
            Button(action: {
                self.showForm.toggle()
                
            }) {
                HStack{
                Text("    Contact Property Manager").font(.headline)
                    //.renderingMode(.original)
                    .padding(.top, 25)
                    .padding(.bottom, 15)
                    .foregroundColor(.white)
                    .sheet(isPresented: $showForm) {
                        PropertyManagerForm(token: $token, user_id: $user_id, user : $user, building: building, showForm:self.$showForm)
                }
            }
            .padding(.horizontal, 10)
            //.padding(.vertical, self.height > 800 ? 15 : 10)
            .background(LinearGradient(gradient: .init(colors: [Color("lightpurple"),Color("pink"),Color("orange")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            
            .clipShape(CustomShape(corner: .bottomLeft, radii: self.height > 800 ? 35 : 30))
        }
        .offset(y:-105)
        }
    }
}
}

struct BuildingView: View {
    func convertBedrooms(bedrooms: Int) -> Int {
        if (bedrooms > 3){
            return 3
        }
        else{
            return bedrooms
        }
    }
    @State var show = false
    @State var showForm = false
    @State var isFavorite = true
    var Bedrooms = ["Studio", "1", "2", "3+"]
    @State var Bedroom : Int
    @Binding var user : User
    @State private var showPopUp = false
    @State private var floorplanURL = ""
    @State private var height = UIScreen.main.bounds.height
    @State private var width = UIScreen.main.bounds.width
    @Binding var showCard: Bool
    @State private var index = 0
    @State private var value : CGFloat = 200
    @Binding var token: String
    @Binding var user_id: String
    @State var expand = false
    var building: Building
    
   
    
    var body: some View {
        ZStack{
        VStack{
            BuildingImages(token: $token, user : $user, user_id: $user_id, building: building)
        ScrollView(showsIndicators: false){
            VStack{
                
                Text(building.name).font(.largeTitle)
                    .foregroundColor(Color.gray)
                Text(building.address.streetAddress).multilineTextAlignment(.center)
                Spacer()
                Spacer()
                Text("Message Our Tenants").fontWeight(.heavy).padding(.top,4)
                    .foregroundColor(Color.gray)
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        
                        Loader(show: self.$show)
                        
                        HStack{
                           
                            Chats(token: $token, user_id: $user_id, building:building, expand: self.$expand)
                                .offset(y:-100)
                        }
                    }.offset(y:0)
                    
                    VStack(alignment: .leading){
                        Text("Description").fontWeight(.heavy).padding(.top,4)
                            .foregroundColor(Color.gray)
                        Spacer()
                        Text(building.description).fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color.gray)
                        
                    }.padding(.horizontal)
                    .offset(y:-115)
                    VStack(alignment: .leading){
                        Text("Building Amenities").foregroundColor(Color.gray).fontWeight(.heavy).padding(.bottom,-5).offset(y: 20)
                        HStack(spacing: 0){
                            
                            HStack(spacing: 15){
                                
                                Image("s3")
                                    .frame(width: 60, height: 60)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.purple.opacity(0.2), radius: 5, x: -5, y: -5)
                                    .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)
                                
                                VStack(alignment: .center){
                                    
                                    Text("Gym")
                                        .foregroundColor(.purple)
                                    
                                    Text("6AM-11PM")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer(minLength: 0)
                            
                            HStack(spacing: 15){
                                
                                Image("s2")
                                .frame(width: 60, height: 60)
                                    .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.purple.opacity(0.2), radius: 5, x: -5, y: -5)
                                .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)
                                
                                VStack(alignment: .center){
                                    
                                    Text("Pool")
                                        .foregroundColor(.purple)
                                    
                                    Text("6AM-11PM")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical)
                        .offset(y:20)
                        HStack(spacing: 0){
                            
                            HStack(spacing: 15){
                                
                                Image("s1")
                                    .frame(width: 60, height: 60)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.purple.opacity(0.2), radius: 5, x: -5, y: -5)
                                    .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)
                                
                                VStack(alignment: .center){
                                    
                                    Text("Game Nights")
                                        .foregroundColor(.purple)
                                    
                                    Text("Weekends")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer(minLength: 0)
                            
                            HStack(spacing: 15){
                                
                                Image("s4")
                                .frame(width: 60, height: 60)
                                    .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.purple.opacity(0.2), radius: 5, x: -5, y: -5)
                                .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)
                                
                                VStack(alignment: .center){
                                    
                                    Text("Wifi")
                                        .foregroundColor(.purple)
                                    
                                    Text("All Day")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical)
                        .offset(y:20)
                       
                        
                    }.padding(.horizontal)
                    .offset(y:-95)
                    Spacer()
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Units").fontWeight(.heavy).padding(.top,4)
                            .foregroundColor(Color.gray)
                        Picker(selection: $Bedroom, label:
                            Text(Bedrooms[Bedroom]).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                    .background(Color.white)
                        ) {
                            ForEach(0 ..< Bedrooms.count) {
                                Text(self.Bedrooms[$0])
                            }
                            .padding(1.0)
                            }.pickerStyle(SegmentedPickerStyle())
                        ForEach(building.units, id:\.number){unit in
                            if (convertBedrooms(bedrooms:unit.bedrooms) == Bedroom) {
                                Button(action: {
                                    self.showPopUp = true
                                    self.floorplanURL = unit.floorPlan
                                    }, label: {
                                        HStack{
                                            Text("\(unit.number)")
                                            Spacer()
                                            HStack{
                                            Text("\(unit.bedrooms)")
                                                Image("Bed").resizable().frame(width: 25, height: 25)
                                            }
                                            Spacer()
                                            HStack{
                                            Text("\(unit.bathrooms)")
                                                Image("Bath").resizable().frame(width: 35, height: 35)
                                            }
                                            Spacer()
                                            HStack{
                                            Text("\(unit.squareFeet)")
                                                Image("Square").resizable().frame(width: 25, height: 20)
                                            }
                                            Spacer()
                                            Text("$\(Int(unit.price))")
                                        }.padding(.horizontal)
                                    }).foregroundColor(.black)
                            }
                        }
                    }.padding(.horizontal)
                    .offset(y: -90)
                }
                BuildingMapView(address:building.address).frame(width: UIScreen.main.bounds.width-40, height: 200).offset(y: -90)
                
            }
        }.background(Color(.white))
        Button(action: {
                self.showCard.toggle()
            }) {
               
        }.offset(x:-170,y:290)
        }.edgesIgnoringSafeArea([.top, .bottom])
            if $showPopUp.wrappedValue {
                ZStack {
                    Color.white
                    VStack {
                        if (floorplanURL != ""){
                            Text("Floorplan")
                            URLImage(url: floorplanURL)
                        }
                        else {
                            Text("No floorplan available")
                        }
                        Spacer()
                        Button(action: {
                            self.showPopUp = false
                        }, label: {
                            Text("Close")
                        })
                    }.padding()
                }
                .frame(width: 300, height: 200)
                .cornerRadius(20).shadow(radius: 20)
            }
    }
    }}


struct CircleImage: View {
    var image: Image
    var body: some View {
        image.resizable()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .shadow(radius: 10)
    }
}

struct ImageSlider: View {
    var images: [String]
    @Binding var isFavorite: Bool
    var body: some View {
        ZStack{
        TabView {
                ForEach(images, id: \.self) {image in
                    URLImage(url: image)
                        .frame(width:UIScreen.main.bounds.width, height: 250)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
          
        }
        }
}

struct Loader : View {
    
    @State var width : CGFloat = 100
    @Binding var show : Bool
    var time = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var secs : CGFloat = 0
    
    var body : some View{
        
        ZStack(alignment: .leading){
            
            Rectangle()
                .fill(Color.white.opacity(0.6))
                .frame(height: 3)
            
            Rectangle()
                .fill(Color.white)
                .frame(width: self.width, height: 3)
        }
        .onReceive(self.time) { (_) in
            
            self.secs += 0.1
            
            if self.secs <= 6{//6 seconds.....
                
                let screenWidth = UIScreen.main.bounds.width
                
                self.width = screenWidth * (self.secs / 6)
            }
            else{
                
                self.show = false
            }

        }
    }
}

struct CustomShape : Shape {
    
    var corner : UIRectCorner
    var radii : CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
        
        return Path(path.cgPath)
    }
}


struct BuildingMapView: UIViewRepresentable {
    var address : Address
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
    
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        coordinates(forAddress: "\(address.streetAddress), \(address.city), \(address.state), \(address.zipCode)") {
            (location) in
            guard let location = location else {
                return
            }
            let coordinate = CLLocationCoordinate2D(
                latitude: location.latitude, longitude: location.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            
            uiView.setRegion(region, animated: true)
            let newPin = MKPointAnnotation()
            newPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            uiView.addAnnotation(newPin)
        }
    }
}



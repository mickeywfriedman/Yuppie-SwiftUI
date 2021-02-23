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
    @Environment(\.colorScheme) var colorScheme
    var building: Building
    var body: some View{
        ZStack{
        ImageSlider(images: building.images, isFavorite: $isFavorite)
            .frame(height: 250)
            .clipShape(CustomShape(corner: .bottomLeft, radii: self.height > 800 ? 65: 60))
        Button(action: {
                toggleFavorite()
            }) {
            
            Label(title: {
               
                
            }) {
                
                
                if (user.favorites.contains(building.id)) {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(Color("Chat_color"))
                                        } else {
                                            Image(systemName: "heart")
                                                .foregroundColor(Color.gray)
                                        }
            }
            .padding(.vertical,8)
            .padding(.horizontal,10)
            .background(Color("pgradient2"))
            .clipShape(Capsule())
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
                .background(LinearGradient(gradient: .init(colors: [Color("pgradient1"),Color("Chat_color")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            
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
            Color.white
        VStack{
            BuildingImages(token: $token, user : $user, user_id: $user_id, building: building).background(Color.white)
        ScrollView(showsIndicators: false){
            VStack{
                
                Text(building.name).font(.largeTitle)
                    .foregroundColor(Color.gray)
                Text(building.address.streetAddress).multilineTextAlignment(.center).foregroundColor(Color.gray)
                Spacer()
                Spacer()
                Text("Message Our Tenants").fontWeight(.heavy).padding(.top,4)
                    .foregroundColor(Color.gray)
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        
                        Loader(show: self.$show)
                        
                        HStack{
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                           
                                Chats(token: $token, user: $user, user_id: $user_id, building:building, expand: self.$expand)
                                .offset(y:-100)
                                .padding(.top, 15)
                            }}
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
                        BottomView(amenities: building.amenities)
                       
                        
                    }
                    .offset(y:-95)
                    Spacer()
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Units").fontWeight(.heavy)
                            .foregroundColor(Color.gray)
                        Picker(selection: $Bedroom, label:
                            Text(Bedrooms[Bedroom])
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
                                                Image("Bed").resizable().frame(width: 25, height: 25).foregroundColor(.purple)
                                            }
                                            Spacer()
                                            HStack{
                                            Text("\(unit.bathrooms)")
                                                Image("Bath").resizable().frame(width: 35, height: 35).foregroundColor(.purple)
                                            }
                                            Spacer()
                                            HStack{
                                            Text("\(unit.squareFeet)")
                                                Image("Square").resizable().frame(width: 25, height: 20).foregroundColor(.purple)
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
                BuildingMapView(building:building).frame(width: UIScreen.main.bounds.width-40, height: 200).offset(y: -90)
                
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
                    ImageView(url: image)
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
    var building : Building
    func makeUIView(context: Context) -> MKMapView {
    
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let lat = Double(building.latitude) as! CLLocationDegrees
        let lon = Double(building.longitude) as! CLLocationDegrees
        let coordinate = CLLocationCoordinate2D(
            latitude: lat, longitude: lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        uiView.setRegion(region, animated: true)
        let newPin = MKPointAnnotation()
        newPin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        uiView.addAnnotation(newPin)
    }
}

struct BottomView : View {
    var amenities: [String]
    var body : some View{
        
        VStack{
            
            HStack{
                
                Text("Building Amenities").fontWeight(.heavy).foregroundColor(.gray)
                
                Spacer()

                
            }.padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top){
                    ForEach(amenities, id:\.self){
                        amenity in
                        VStack(spacing: 8){
                            VStack{
                                Image(amenity)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            }
                                
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.top, 25)
                                .shadow(color: Color.purple.opacity(0.2), radius: 5, x: -5, y: -5)
                                .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)
                            Text(amenity)
                            //.frame(width: 55)
                            .font(.caption)
                            .foregroundColor(Color.black.opacity(0.5))
                            .multilineTextAlignment(.center)
                        }.padding(.leading)
                    }
                }
            }
            .padding(.bottom, 15)
        }
    }
}

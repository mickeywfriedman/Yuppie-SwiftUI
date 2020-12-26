//
//  BuildingView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI
import MapKit

struct BuildingImages: View{
    @State var isFavorite = true
    @State var showForm = false
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    var building: Building
    var body: some View{
        ZStack{
        ImageSlider(images: building.images, isFavorite: $isFavorite)
            .frame(height: 250)
            .clipShape(CustomShape(corner: .bottomLeft, radii: self.height > 800 ? 65: 60))
            
        
        
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
                        PropertyManagerForm(showForm:self.$showForm)
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
    @State var showForm = false
    @State var isFavorite = true
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    @Binding var showCard: Bool
    @State var index = 0
    @State var value : CGFloat = 200
    var building: Building
    var body: some View {
        VStack{
            BuildingImages(building: building)
        ScrollView(showsIndicators: false){
            VStack{
                
                Text(building.name).font(.largeTitle)
                    .foregroundColor(Color.gray)
                Text(building.address).multilineTextAlignment(.center)
                Spacer()
                Spacer()
                Text("Message Our Tenants").fontWeight(.heavy).padding(.top,4)
                    .foregroundColor(Color.gray)
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        
                        HStack{
                           
                            Home()
                        }
                    }.offset(y:-95)
                    
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
                                    
                                    Text("Weekends")
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
                                
                                VStack(alignment: .leading){
                                    
                                    Text("Wifi")
                                        .foregroundColor(.purple)
                                    
                                    Text("6AM-11PM")
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
                        Text("Select Unit Size").fontWeight(.heavy).padding(.top,4).padding(.bottom, 15).foregroundColor(Color.gray).offset(x: -8)
                        
                        HStack(spacing: 0){
                            
                            Button(action: {
                                
                                self.index = 0
                                
                            }) {
                                
                                Text("1 🛏️")
                                    .foregroundColor(self.index == 0 ? .white : Color.black.opacity(0.6))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 25)
                                    .background(self.index == 0 ? Color("Chat_color") : Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: Color.purple.opacity(0.2), radius: 5, x: -5, y: -5)
                                    .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)
                            }
                            Spacer()
                            
                            Button(action: {
                                
                                self.index = 1
                                
                            }) {
                                
                                Text("2 🛏️")
                                    .foregroundColor(self.index == 1 ? .white : Color.black.opacity(0.6))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 25)
                                    .background(self.index == 1 ? Color("Chat_color") : Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: Color.purple.opacity(0.2), radius: 5, x: -5, y: -5)
                                    .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)
                            }
                            Spacer()
                            
                            Button(action: {
                                
                                self.index = 2
                                
                            }) {
                                
                                Text("3 🛏️")
                                    .foregroundColor(self.index == 2 ? .white : Color.black.opacity(0.6))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 25)
                                    .background(self.index == 2 ? Color("Chat_color") : Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: Color.purple.opacity(0.2), radius: 5, x: -5, y: -5)
                                    .shadow(color: Color.gray.opacity(0.7), radius: 5, x: 5, y: 5)                            }
                            
                            Spacer()
                        }

                        
                        if self.index == 0{
                            
                            HStack(spacing: 20){
                                
                                VStack(alignment: .leading){
                                    
                                    Text("#0502")
                                        .foregroundColor(Color.purple.opacity(0.8))
                                    
                                    Text("#0409")

                                        .foregroundColor(Color.purple.opacity(0.8))
                                }
                                Spacer()
                                
                                VStack(alignment: .leading){
                                    
                                    Text("$2,075")
                                        .foregroundColor(Color.black.opacity(0.4))
                                    
                                    Text("$2,195")
                                        .foregroundColor(Color.black.opacity(0.4))
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading){
                                    
                                    Text("1🛀")

                                        .foregroundColor(Color.black.opacity(0.4))
                                    
                                    Text("1🛀")
                                        .foregroundColor(Color.black.opacity(0.4))
                                }
                                Spacer()
                                
                                VStack(spacing: 12){
                                    
                                    Text("718 sqft")
                                       
                                        .foregroundColor(Color.black.opacity(0.4))
                                        .background(Color.white)
                                    .cornerRadius(2)
                                        .shadow(color: Color.gray.opacity(0.3), radius: 1, x: -1, y: -1)
                                        .shadow(color: Color.gray.opacity(0.3), radius: 1, x: 1, y: 1)
                                    
                                    Text("767 sqft")
                                        .foregroundColor(Color.black.opacity(0.4))
                                        .background(Color.white)
                                    .cornerRadius(2)
                                        .shadow(color: Color.gray.opacity(0.3), radius: 1, x: -1, y: -1)
                                        .shadow(color: Color.gray.opacity(0.3), radius: 1, x: 1, y: 1)
                                }

                            }
                            .padding(.top)
                        }
                        else{
                            
                            HStack(spacing: 20){
                                
                                VStack(alignment: .leading){
                                    
                                    Text("#1521")
                                        .foregroundColor(Color.purple.opacity(0.8))
                                    
                                    Text("#1009")

                                        .foregroundColor(Color.purple.opacity(0.8))
                                }
                                Spacer()
                                
                                VStack(alignment: .leading){
                                    
                                    Text("$3,875")
                                        .foregroundColor(Color.black.opacity(0.4))
                                    
                                    Text("$4,182")
                                        .foregroundColor(Color.black.opacity(0.4))
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading){
                                    
                                    Text("2🛀")

                                        .foregroundColor(Color.black.opacity(0.4))
                                    
                                    Text("2🛀")
                                        .foregroundColor(Color.black.opacity(0.4))
                                }
                                Spacer()
                                
                                VStack(spacing: 12){
                                    
                                    Text("1182 sqft")
                                       
                                        .foregroundColor(Color.black.opacity(0.4))
                                        .background(Color.white)
                                    .cornerRadius(2)
                                        .shadow(color: Color.gray.opacity(0.3), radius: 1, x: -1, y: -1)
                                        .shadow(color: Color.gray.opacity(0.3), radius: 1, x: 1, y: 1)
                                    
                                    Text("2142 sqft")
                                        .foregroundColor(Color.black.opacity(0.4))
                                        .background(Color.white)
                                    .cornerRadius(2)
                                    .shadow(color: Color.gray.opacity(0.3), radius: 1, x: -1, y: -1)
                                    .shadow(color: Color.gray.opacity(0.3), radius: 1, x: 1, y: 1)
                                }
                                
                            }
                            .padding(.top)
                        }

                        
                    }
                    .padding(.horizontal, 25)
                    .offset(y: -90)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                  
                    
                }
                
                
                BuildingMapView(address:building.address).frame(width: UIScreen.main.bounds.width-20, height: 200).padding(.leading,10)
            }
        }.background(Color(.white))
        
        Button(action: {
                self.showCard.toggle()
            }) {
               
        }.offset(x:-170,y:290)
        }.edgesIgnoringSafeArea([.top, .bottom])
    }
}


struct unitView : View {
var units: [Unit]
var body : some View {
    VStack{
        
        

        ForEach(units){ unit in
            HStack{
                Text("\(unit.name)")
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
                Text("\(unit.sqft)")
                    Image("Square").resizable().frame(width: 25, height: 20)
                }
                Spacer()
                Text("$\(unit.price)")
            }
        }
    }
}
}

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
                    Image(image)
                        .resizable()
                        .frame(width:UIScreen.main.bounds.width, height: 250)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
          
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
    var address : String
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
        coordinates(forAddress: address) {
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

struct BuildingView_Previews: PreviewProvider {
    static var previews: some View {
        BuildingView(showCard:.constant(true), building: TestData.buildings.first!)
    }
}


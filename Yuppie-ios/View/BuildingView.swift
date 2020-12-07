import SwiftUI
import MapKit

struct BuildingView: View {
    @State var showForm = false
    @State var isFavorite = true
    @Binding var showCard: Bool
    var building: Building
    var body: some View {
        ZStack{
        ScrollView(showsIndicators: false){
            VStack{
                ImageSlider(images: building.images, isFavorite: $isFavorite)
                Text(building.name).fontWeight(.heavy).font(.largeTitle)
                Text(building.address).multilineTextAlignment(.center)
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text("Your Network").fontWeight(.heavy)
                        HStack{
                            CircleImage(image:Image("Leon"))
                            CircleImage(image:Image("Ryan"))
                            CircleImage(image:Image("Mickey"))
                            Text("and 5 More")
                        }
                    }.padding()
                    
                    VStack(alignment: .leading){
                        Text("Description").fontWeight(.heavy).padding(.top,4)
                        Text(building.description).fixedSize(horizontal: false, vertical: true)
                        
                    }.padding(.horizontal)
                    
                    VStack(alignment: .leading){
                        Text("Available Units").fontWeight(.heavy).padding(.bottom,-5)
                        unitView(units: building.units)
                    }.padding()
                    
                    VStack(alignment: .leading){
                    Text("Amenities").fontWeight(.heavy).padding(.bottom,-5)
                    HStack{
                        ForEach(building.amenities, id: \.self){amenity in
                            Image(amenity)
                            .resizable()
                            .frame(width: 50, height: 50)
                            Spacer()
                        }
                    }
                    }.padding()
                }
                
                VStack{
                        Button(action: {
                            self.showForm.toggle()
                        }) {
                           Text("Contact Property Manager").font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: UIScreen.main.bounds.width-20, height: 50)
                                .background(Color.blue)
                                .cornerRadius(15.0)
                            }
                }.sheet(isPresented: $showForm) {
                    PropertyManagerForm(showForm:self.$showForm)
                }
                BuildingMapView(address:building.address).frame(width: UIScreen.main.bounds.width-20, height: 200).padding(.leading,10)
            }
        }.background(Color.white)
        
        Button(action: {
                self.showCard.toggle()
            }) {
                Image(systemName: "x.circle")
                    .foregroundColor(Color.gray)
        }.offset(x:-170,y:-360)
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
            Button(action: {
                    self.isFavorite.toggle()
                }) {
                    if self.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "heart")
                                .foregroundColor(Color.gray)
                        }
            }.offset(x:170,y:-105)
        }
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

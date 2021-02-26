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
    @State var card = ""
    @State var showCard = false
    @State var index: Int = 0
    @State var expand = false
    @Binding var user : User
    @Binding var token: String
    @Binding var user_id: String
    @State var minDate = Date()
    @State var maxDate = Date(timeInterval: 14*86400, since: Date())
    func reset() -> Void {
        index = 0
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
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                MapView(annotations: annotations(), buildings: $buildings, index: $index).centerCoordinate(CLLocationCoordinate2D(latitude: Double(buildings[index].latitude), longitude: Double(buildings[index].longitude))).zoomLevel(15).offset(y:-450).onDisappear(perform: {
                    reset()
                })
                VStack{
                    HStack{
                        Text("Chat with Current Residents")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .padding(.vertical,4)
                        .padding(.horizontal,10)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .opacity(0.7)
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
                        ForEach(buildings, id:\.name) {building in
                            Chats(token: $token, user: $user, user_id: $user_id, building:building, expand: self.$expand)
                                .padding(.top, -75).padding(.horizontal, 20)
                            }
                        }
                   .frame(width: geometry.size.width, alignment: .leading)
                    .offset(x: -CGFloat(self.index) * geometry.size.width)
                   .animation(.interactiveSpring())
                    
                }.offset(y: -350)
            HStack (spacing: 0){
                ForEach(buildings, id:\.name) {building in
                        CardView(token: $token, user: $user, user_id: $user_id, building:building, showCard: $showCard, card: $card)
                            .padding(.horizontal, 20)
                    }
                }
           .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.index) * geometry.size.width, y: -200)
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
                    print(buildings[index].name)
                 }
           )
        }.sheet(isPresented: $showCard) {
            sheets(card: $card, user: $user, buildings: buildings, user_id: $user_id, token:$token, index: $index)
        }
        }
}
}

struct sheets: View {
    @Binding var card: String
    @Binding var user: User
    @State var buildings: [Building]
    @Binding var user_id: String
    @Binding var token: String
    @Binding var index: Int
    @State var minDate = Date()
    @State var maxDate = Date(timeInterval: 14*86400, since: Date())
    func reset() -> Void {
        index = 0
    }
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    func format(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    func updateFilters() -> Void {
        self.user.preferences.earliestMoveInDate = "\(format(date: minDate))"
        self.user.preferences.latestMoveInDate = "\(format(date: maxDate))"
        guard let filter_url = URL(string: "http://18.218.78.71:8080/users/\(user_id)") else {
            print("Your API end point is Invalid")
            return
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(update(preferences: user.preferences)) else {
            print("Failed to encode order")
            return
        }
        var filter_request = URLRequest(url: filter_url)
        filter_request.httpMethod = "PATCH"
        filter_request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        filter_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        filter_request.httpBody = data
        print("updated")
        URLSession.shared.dataTask(with: filter_request) { data, response, error in
            return
            
        }.resume()
    }
    func unitFilter(unit: Unit) -> Bool{
        if (unit.bedrooms >= user.preferences.bedrooms && unit.bathrooms >= user.preferences.bathrooms){
                return true
            }
            return false
        }
    
    func minBeds () -> Int{
        var lowest = 3
        for unit in buildings[index].units.filter({unitFilter(unit:$0)}) {
            if (Int(unit.bedrooms) < lowest){
                lowest = unit.bedrooms
            }
        }
        return lowest
    }
    var body: some View {
        if (card == "filter"){
        VStack{
            Text("Update Preferences").font(.largeTitle).fontWeight(.heavy)
        FiltersView(token: $token, user: $user, user_id: $user_id, minDate: dateFormat(string: user.preferences.earliestMoveInDate), maxDate: dateFormat(string: user.preferences.latestMoveInDate)).onDisappear(perform: updateFilters)
        }.padding().onDisappear(perform: {
            reset()
        })
        }
        else if (card == "building") {
            BuildingView(Bedroom: minBeds(), user : $user, token: $token, user_id: $user_id, building:buildings[index])
        } else {
            Text("oops\(card) sadf")
        }
        }
}

struct Navshape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        
        return Path(path.cgPath)
    }
}



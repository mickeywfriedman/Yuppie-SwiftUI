//
//  Favorites.swift
//  Yuppie-ios
//
//  Created by Ryan Cao on 1/22/21.
//

import SwiftUI

struct Favorites: View {
    @Binding var token: String
    @Binding var user_id: String
    @Binding var buildings : [Building]
    @Binding var user : User
    @Binding var minBedrooms : Int
    @Binding var minBathrooms : Int
    var Tabs = ["Favorites", "Contacted"]
    func findFavorites () -> [Building] {
        var filteredBuildings = [Building]()
        for building in buildings{
            print(building.id)
            print(user)
            if (user.favorites.contains(building.id)){
                filteredBuildings.append(building)
            }
        }
        return filteredBuildings
    }
    func findContacted () -> [Building] {
        var filteredBuildings = [Building]()
        for building in buildings{
            if (user.contacted.contains(building.id)){
                filteredBuildings.append(building)
            }
        }
        return filteredBuildings
    }
    @State var Tab = 0
    var body: some View {
        VStack{
            Picker(selection: $Tab, label:
                Text(Tabs[Tab])
            ) {
                ForEach(0 ..< Tabs.count) {
                    Text(self.Tabs[$0])
                }
                }.pickerStyle(SegmentedPickerStyle())
            .padding()
            if (Tabs[Tab] == "Favorites") {
                if (findFavorites().count>0){
                    ForEach(findFavorites(), id:\.name) { building in
                        BuildingRow(token: $token, user: $user, user_id: $user_id, building: building, minBedrooms: minBedrooms, minBathrooms: minBathrooms)
                    }
                } else {
                    Text("You have not liked any buildings")
                }
                
            } else {
                if (findContacted().count>0){
                    ForEach(findContacted(), id:\.name) { building in
                        BuildingRow(token: $token, user: $user, user_id: $user_id, building: building, minBedrooms: minBedrooms, minBathrooms: minBathrooms)
                    }
                } else {
                    Text("You have not contacted any buildings")
                }
            }
            Spacer()
        }
    }
}

struct BuildingRow: View {
    @Binding var token: String
    var Bedrooms = ["Studios", "1 Br", "2 BR", "3+ Br"]
    @Binding var user : User
    @Binding var user_id: String
    var building: Building
    var minBedrooms: Int
    var minBathrooms: Int
    func unitFilter(unit: Unit, minBathrooms: Int, minBedrooms: Int) -> Bool{
        if (unit.bedrooms >= minBedrooms && unit.bathrooms >= minBathrooms){
            return true
        }
        return false
    }
    func minPrice (building: Building, minBedrooms: Int, minBathrooms: Int) -> Int {
        var minPrice = 100000
        for unit in building.units.filter({unitFilter(unit:$0, minBathrooms:minBathrooms,minBedrooms:minBedrooms)}) {
            if (Int(unit.price) < minPrice){
                minPrice = Int(unit.price)
            }
        }
        return minPrice
    }
    @State var isFavorite = true
    @State var showCard = false
    var body: some View {
            ZStack{
                VStack{
                    VStack{
                        Text("   ")
                        Text("   ")
                        VStack{
                            
                            HStack{
                                
                                
                                VStack{
                                    Text("\(Bedrooms[minBedrooms]) starting from").fontWeight(.heavy)
                                    Text("$\(minPrice(building:building, minBedrooms:minBedrooms, minBathrooms:minBathrooms))")
                                                                        
                                }.foregroundColor(.gray)
                                Spacer()
                                HStack{
                                    VStack{
                                        Text(building.name).fontWeight(.heavy)
                                        Text(building.address.streetAddress)}
                                    }.foregroundColor(.gray)
                            }.padding(.top, 160)
                            .padding()
                        }.background(Color("Color"))
                        .cornerRadius(14)
                        .frame(width:UIScreen.main.bounds.width-40)
                    }
                }.sheet(isPresented: $showCard) {
                    BuildingView(Bedroom: minBedrooms, user : $user, showCard:self.$showCard, token: $token, user_id: $user_id, building:building)
                }
                
                ZStack{
                    FavoritesImageScroll(building: building, user: $user, token: $token, user_id: $user_id)
                .frame(width:UIScreen.main.bounds.width-40, height: 200)
                    .cornerRadius(20)
                    
                    Button(action: {self.showCard.toggle()}, label: {
                        
                        Image(systemName: "arrow.up")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.all)
                            .background(Color("Color-3"))
                            .clipShape(Circle())
                        // adding neuromorphic effect...
                            
                    }).offset(y:95)
                }.offset(y:-40)
    }
        }
    }

struct FavoritesImageScroll: View {
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
                if let data = data {
                    if let urlresponse = try? JSONDecoder().decode(userResponse.self, from: data) {
                        DispatchQueue.main.async {
                            print(urlresponse)
                        }
                        return
                    }
                    
                }
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
                if let data = data {
                    if let urlresponse = try? JSONDecoder().decode(userResponse.self, from: data) {
                        DispatchQueue.main.async {
                            print(urlresponse)
                        }
                        return
                    }
                    
                }
            }.resume()
    }
    func toggleFavorite() -> Void {
        if (user.favorites.contains(building.id)) {
            deleteFavorite()
        } else{
            addFavorite()
        }
    }
    @GestureState private var translation: CGFloat = 0
    @State var index: Int = 0
    var building: Building
    @Binding var user: User
    @Binding var token: String
    @Binding var user_id: String
    var body: some View {
        ZStack{
        GeometryReader { geometry in
            HStack (spacing: 0){
                ForEach(building.images, id: \.self) {image in
                    URLImage(url:image)
                        .frame(width:UIScreen.main.bounds.width-40, height: 200)
                            .cornerRadius(20)
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
                    self.index = min(max(Int(newIndex), 0), self.building.images.count - 1)
                 }
           )
        }
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
                }.offset(x: (-1*(UIScreen.main.bounds.width-40)/2)+20, y: -80)
    }
    }
}

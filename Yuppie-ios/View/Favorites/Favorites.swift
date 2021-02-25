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
    var gradient = [Color("Color-3"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
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
                    ScrollView{
                        VStack{
                            ForEach(buildings.filter({user.favorites.contains($0.id)}), id:\.name) { building in
                                BuildingRow(token: $token, user: $user, user_id: $user_id, building: building, minBedrooms: minBedrooms, minBathrooms: minBathrooms)
                            }
                        }
                    }
                } else {
                    VStack{
                        
                    Text("You have not liked any buildings")
                        .foregroundColor(Color.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .offset(y: 50)
                        
                        Image("buildings")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    }
                }
                
            } else {
                if (findContacted().count>0){
                    ScrollView{
                        VStack{
                            ForEach(findContacted(), id:\.name) { building in
                                BuildingRow(token: $token, user: $user, user_id: $user_id, building: building, minBedrooms: minBedrooms, minBathrooms: minBathrooms)
                            }
                        }
                    }
                } else {
                    Text("You have not contacted any buildings")
                        .foregroundColor(Color.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .offset(y: 50)
                        
                    Image("buildings")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            Spacer()
        }.background(
            
            LinearGradient(gradient: .init(colors: gradient), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
        )
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
    func unitFilter(unit: Unit) -> Bool{
        if (unit.bedrooms >= user.preferences.bedrooms && unit.bathrooms >= user.preferences.bathrooms){
                return true
            }
            return false
        }
    func minPrice (building: Building) -> Int {
        var minPrice = 100000
        for unit in building.units.filter({unitFilter(unit:$0)}) {
            if (Int(unit.price) < minPrice){
                minPrice = Int(unit.price)
            }
        }
        return minPrice
    }
    func minBeds () -> Int{
        var lowest = 3
        for unit in building.units.filter({unitFilter(unit:$0)}) {
            if (Int(unit.bedrooms) < lowest){
                lowest = unit.bedrooms
            }
        }
        return lowest
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
                                    if minPrice(building:building) == 100000{
                                        Text("No \(Bedrooms[user.preferences.bedrooms])").fontWeight(.heavy)
                                    } else{
                                        Text("\(Bedrooms[minBeds()]) from ").fontWeight(.heavy)
                                        Text("$\(minPrice(building:building))")
                                    }
                                                                        
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
                        .shadow(color: Color("blueshadow").opacity(0.1),radius: 5,x: -5,y: -5)
                        .shadow(color: Color.gray.opacity(0.86),radius: 7,x: 5,y: 5)
                    }
                }.sheet(isPresented: $showCard) {
                    BuildingView(Bedroom: minBeds(), user : $user, token: $token, user_id: $user_id, building:building)
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
            }.offset(x: (-1*(UIScreen.main.bounds.width-40)/2)+20, y: -80)
    }
    }
}

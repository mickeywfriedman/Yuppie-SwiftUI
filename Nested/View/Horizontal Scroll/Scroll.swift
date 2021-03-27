//
//  testScroll.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//
import SwiftUI
import Mapbox


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
    @State var tenant_id = ""
    @State var tenant_prof = ""
    @State var tenant_name = ""
    @State var showChatUI = false
    @State var search = ""
    @State var showInbox = false
    @State var first = true
    var gradient = [Color("Color-3"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    func loadData() {
        if (self.token != "") {
            print(self.token, "SUHSHHHS")
            guard let url = URL(string: "http://18.218.78.71:8080/buildings") else {
                print("Your API end point is Invalid")
                return
            }
            var request = URLRequest(url: url)
            request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            print(self.token)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let response = try? JSONDecoder().decode(Response.self, from: data) {
                        DispatchQueue.main.async {
                            self.buildings = response.data
                            print("hello")
                            print(user_id)
                        }
                        return
                    }
                }
            }.resume()
        }
        }
    func moveMap () -> Void {
        let seconds = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.first = false
        }
        
    }
    func getDocumentsDirectory1() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func writeTenant(){
        let text = ""
        
        let filename = getDocumentsDirectory1().appendingPathComponent("index.txt")
        do {
            try text.write(to: filename, atomically: false, encoding: .utf8)
            try (self.tenant_id+self.user_id+("token_id:")+self.token ).write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
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
        }
        return false
    }
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
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                MapView(buildings: $buildings, index: $index, user: $user, first: $first).centerCoordinate(CLLocationCoordinate2D(latitude: Double(buildings[index].latitude), longitude: Double(buildings[index].longitude))).zoomLevel(15).offset(y:-50).onDisappear(perform: {
                    reset()
                })
                if filteredBuildings().count == 0 {
                    ZStack{
                        LinearGradient(gradient: .init(colors: gradient), startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
                        VStack{
                            Text("No buildings match your preferences")
                            Button(action: {
                                self.card = "filter"
                                self.showCard = true
                                }) {
                                Label(title: {
                                }) {
                                    Text("Adjust Preferences Here").foregroundColor(.black)
                                }
                                .padding(.vertical,8)
                                .padding(.horizontal,10)
                                .background(Color("Color1"))
                                .clipShape(Capsule())
                            }
                            Image("buildings")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        }
                    }
                } else{
                Image("topgradient")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                .offset(y:-310)
                    .frame(width:UIScreen.main.bounds.width)
                    
                    Image("bottomgradient")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    .offset(y:225)
                        .frame(width:UIScreen.main.bounds.width)
                        
                    Image("arrows")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    .offset(y: ((UIScreen.main.bounds.height)/2)-220)
                        .shadow(color: Color.black.opacity(0.90),radius: 7,x: -7,y: -7)
                        .shadow(color: Color.gray.opacity(0.86),radius: 7,x: 5,y: 5)
                        .frame(width:UIScreen.main.bounds.width)
                    
                    
                        .frame(width:UIScreen.main.bounds.width)
                VStack{
                    HStack{
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
                            .background(Color("Chat_color").opacity(0.75))
                            .clipShape(Capsule())
                        }
                        Text("Our Residents")
                            .foregroundColor(Color.black)
                            .fontWeight(.bold)
                            .padding(.vertical,4)
                        .padding(.horizontal,10)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .opacity(0.7)
                            .onAppear(perform: loadData)
                        Button(action: {
                            self.showCard.toggle()
                            self.card = "inbox"
                        }) {
                            Label(title: {
                            }) {
                            Image(systemName: "message")
                                .foregroundColor(Color.white)
                            }
                            .padding(.vertical,8)
                            .padding(.horizontal,10)
                            .background(Color("Chat_color").opacity(0.75))
                            .clipShape(Capsule())
                        }
                        Button(action: {
                            self.showCard.toggle()
                            self.card = "invite"
                        }) {
                            Label(title: {
                            }) {
                            Image(systemName: "person.badge.plus")
                                .foregroundColor(Color.white)
                            }
                            .padding(.vertical,8)
                            .padding(.horizontal,10)
                            .background(Color("Chat_color").opacity(0.75))
                            .clipShape(Capsule())
                        }
 
                    }
                    HStack(spacing: 0){
                        ForEach(filteredBuildings(), id:\.name) {building in
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack{
                                if building.tenants.count == 0 {
                                    Text("").frame(width: 68, height: 100)
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
                                        ImageView(url: tenant.profilePicture)
                                        .frame(width: 60, height: 60)
                                            .cornerRadius(30)
                                            .padding(.bottom, 10)
                                            .padding(.top, 10)
                                            
                                        Circle()
                                        .trim(from: 0, to: 1)
                                            .stroke(AngularGradient(gradient: .init(colors: [.purple,Color("orange"),.purple]), center: .center), style: StrokeStyle(lineWidth: 4, dash: [showChatUI ? 3 : 0]))
                                        .frame(width: 68, height: 68)
                                        .rotationEffect(.init(degrees: showChatUI ? 360 : 0))
                                            
                                        }
                                            
                                            Label(title: {
                                            }) {Text(tenant.firstName)
                                                .font(.custom("Futura", size: 14))
                                                .foregroundColor(Color.black)
                                                .lineLimit(1)
                                            } .padding(.vertical,4)
                                            .padding(.horizontal,10)
                                            .background(Color.white)
                                            .clipShape(Capsule())
                                            .opacity(0.8)
                                            .offset(y: -6)
                                        }.padding(5)
                                    }
                                }

                                .background(Color.clear)
                                .clipShape(shape())
                                .animation(.default)
                                
                            }.padding(.leading)
                            }.frame(minWidth:(UIScreen.main.bounds.width), maxWidth: geometry.size.width)
                        }
                    }
                   .frame(minWidth: geometry.size.width, maxWidth: geometry.size.width, alignment: .leading)
                    .offset(x: -CGFloat(self.index) * (geometry.size.width))
                   .animation(.interactiveSpring())
                   
                }.offset(y: -1*((UIScreen.main.bounds.height)/2)+140)
            HStack (spacing: 0){
                ForEach(filteredBuildings(), id:\.name) {building in
                        CardView(token: $token, user: $user, user_id: $user_id, building:building, showCard: $showCard, card: $card)
                            .padding(.horizontal, 30)
                    }
                }
           .frame(minWidth: geometry.size.width, maxWidth: .infinity, alignment: .leading)
            .offset(x: -CGFloat(self.index) * geometry.size.width, y: ((UIScreen.main.bounds.height)/2)-240)
           .animation(.interactiveSpring())
            
           .gesture(
              DragGesture()
                 .updating(self.$translation) { gestureValue, gestureState, _ in
                           gestureState = gestureValue.translation.width
                  }
                 .onEnded { value in
                    var weakGesture : CGFloat = 0
                         if value.translation.width < 0 {
                            weakGesture = -120
                         } else {
                            weakGesture = 120
                         }
                    let offset = (value.translation.width + weakGesture) / geometry.size.width
                    let newIndex = (CGFloat(self.index) - offset).rounded()
                    if (min(max(Int(newIndex), 0), filteredBuildings().count - 1) != index){
                    self.index = min(max(Int(newIndex), 0), filteredBuildings().count - 1)
                    }
                    self.first = false
                 }
           )
                     }
        }.sheet(isPresented: $showCard) {
            sheets(card: $card, showCard: $showCard, user: $user, buildings: filteredBuildings(), user_id: $user_id, token:$token, index: $index, tenant_id : $tenant_id, tenant_prof: $tenant_prof, tenant_name:$tenant_name)
        }.onAppear(perform: moveMap)
        }
            
}
}

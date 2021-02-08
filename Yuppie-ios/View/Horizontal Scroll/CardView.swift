import SwiftUI


/// Credit card view
struct CardView: View {
    @Binding var token: String
    @Binding var user : User
    @Binding var user_id: String
    var building: Building
    var Bedrooms = ["Studios", "1 Br", "2 BR", "3+ Br"]
    func unitFilter(unit: Unit) -> Bool{
        if (unit.bedrooms >= user.preferences.bedrooms && unit.bathrooms >= user.preferences.bathrooms){
            return true
        }
        return false
    }
    func minPrice (building: Building) -> Int {
        var minPrice = 100000
        for unit in building.units.filter({unitFilter(unit:$0)}) {
            if (Int(unit.price) < Int(user.preferences.price)){
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
                                    
                                    Text("\(Bedrooms[user.preferences.bedrooms]) from").fontWeight(.heavy)
                                    Text("$\(minPrice(building:building))")
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
                    BuildingView(Bedroom: user.preferences.bedrooms, user : $user, showCard:self.$showCard, token: $token, user_id: $user_id, building:building)
                }
                
                ZStack{
                    ImageScroll(building: building, user : $user, token: $token, user_id: $user_id)
                .frame(width:UIScreen.main.bounds.width-100, height: 200)
                    .cornerRadius(20)
                .shadow(color: Color("blueshadow").opacity(0.1),radius: 5,x: -5,y: -5)
                .shadow(color: Color.gray.opacity(0.86),radius: 7,x: 5,y: 5)
                    
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

struct ImageScroll: View {
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
                        .frame(width:UIScreen.main.bounds.width-100, height: 200)
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
        
            
    }
        HStack{
            
            Spacer(minLength: 0)
            
            Button(action: {
                toggleFavorite()
            }) {
                
                Label(title: {
                    Text("Save")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                    
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
            }
        }.offset(x: (-1*(UIScreen.main.bounds.width-100)/2)-75, y: -80)
    }
}



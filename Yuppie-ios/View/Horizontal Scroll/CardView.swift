import SwiftUI


/// Credit card view
struct CardView: View {
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
                                    Text("\(minPrice(building:building, minBedrooms:minBedrooms, minBathrooms:minBathrooms))+").fontWeight(.heavy)
                                    Text("3 Beds  2 Bath")
                                    
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
                    BuildingView(Bedroom: minBedrooms, showCard:self.$showCard, building:building)
                }
                
                ZStack{
                    ImageScroll(images: building.images)
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
                    }.offset(x:115, y: -80)
                }.offset(y:-40)
    }
        }
    }

struct ImageScroll: View {
    @GestureState private var translation: CGFloat = 0
    @State var index: Int = 0
    var images: [String]
    var body: some View {
        GeometryReader { geometry in
            HStack (spacing: 0){
                ForEach(images, id: \.self) {image in
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
                            self.index = min(max(Int(newIndex), 0), self.images.count - 1)
                 }
           )
        }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.purple
            CardView(building: TestData.buildings.first!, minBedrooms: 1, minBathrooms: 1)
        }
    }
}

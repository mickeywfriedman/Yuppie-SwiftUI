import SwiftUI


/// Credit card view
struct CardView: View {
    var building: Building
    @State var isFavorite = true
    @State var showCard = false
    var body: some View {
            ZStack{
                VStack{
                Button(action: {
                                    self.showCard.toggle()
                            }) {
                    VStack{
                        Text("").padding()
                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    Text("$4200+").fontWeight(.heavy)
                                    Text("3 Beds  2 Bath")
                                    Text(building.name)
                                }.foregroundColor(.black)
                                Spacer()
                                CircleImage(image:Image("Leon"))
                                CircleImage(image:Image("Ryan"))
                                CircleImage(image:Image("Mickey"))
                            }.padding(.top, 200)
                            .padding()
                        }.background(Color.white)
                        .cornerRadius(16)
                    }
                }
                }.sheet(isPresented: $showCard) {
                    BuildingView(showCard:self.$showCard, building:building)
                }
                
                ZStack{
                TabView {
                        ForEach(building.images, id: \.self) {image in
                            Image(image)
                                .resizable()
                        }
                    }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(width:UIScreen.main.bounds.width-40, height: 250)
                    .cornerRadius(16)
                
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
                    }.offset(x:145, y: -100)
                }.offset(y:-40)
            }
        }
    }


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.purple
            CardView(building: TestData.buildings.first!)
        }
    }
}


import SwiftUI

struct FiltersView: View {
    var Bedrooms = ["Studio", "1", "2", "3"]
    @Binding var token: String
    @Binding var user : User
    @Binding var user_id: String
    @Binding var minDate: Date
    @Binding var maxDate: Date
    var Bathrooms = ["1", "2", "3"]
    @State var animals = false
    @State var gym = false
    @State var rooftop = false
    @State var balcony = false
    @State var airConditioning = false
    @State var doorman = false
    @State var appeared = false
    @State var showAmenities = false
    @Environment(\.colorScheme) var colorScheme
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    func updateDates() -> Void {
        if !appeared{
            self.maxDate = dateFormat(string:user.preferences.latestMoveInDate)
            self.minDate = dateFormat(string:user.preferences.earliestMoveInDate)
            self.appeared = true
        }
        
    }
    var isExceeded = false
    var amenities = ["Bike Racks","Furnished","Controlled Access","Washer/Dryer", "Laundry Room", "Elevator"]
    func dateFormat(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    func priceFormat(price : Double) -> String {
        var result = ""
        if (price == 10000) {
            result = "10000+"
        }
        else {
            result = String(format: "%.0f", price)
        }
        return result
    }
    var body: some View {
        ScrollView(showsIndicators: false){
        VStack{
        VStack{
            HStack{
                Text("Number of bedrooms").fontWeight(.heavy)
                Spacer()
            }
            .onAppear(perform: updateDates)
            Picker(selection: $user.preferences.bedrooms, label:
                    Text(Bedrooms[user.preferences.bedrooms])
            ) {
                ForEach(0 ..< Bedrooms.count) {
                    Text(self.Bedrooms[$0])
                }
                .padding(1.0)
                }.pickerStyle(SegmentedPickerStyle())
        
            HStack{
                Text("Number of bathrooms").fontWeight(.heavy)
                Spacer()
            }
            Picker(selection: $user.preferences.bathrooms, label:
                    Text(Bathrooms[user.preferences.bathrooms])
            ) {
                ForEach(0 ..< Bathrooms.count) {
                    Text(self.Bathrooms[$0])
                }
                .padding(1.0)
            }.pickerStyle(SegmentedPickerStyle())
            
            HStack{
                Text("The most I will pay is $\(priceFormat(price:user.preferences.price))").fontWeight(.heavy)
                Spacer()
            }
            Slider(value: $user.preferences.price, in: 1000...10000)
            VStack{
                HStack{
                    Text("Anticipated Move In Date").fontWeight(.heavy)
                    Spacer()
                    
                }
                DatePicker("Earliest Move In", selection: $minDate, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle())
            DatePicker("Latest Move In", selection: $maxDate, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle())
                HStack{
                    Text("I can't live without").fontWeight(.heavy)
                    Spacer()
                }
                VStack(spacing:0){
                    HStack{
                        if user.preferences.amenities.count == 0 {
                            Text("No Features Preference")
                        } else {
                            Text(user.preferences.amenities.joined(separator:", ")).lineLimit(1)
                        }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showAmenities ? 180 : 0))
                        .animation(.easeInOut)
                }.padding()
                .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    .contentShape(Rectangle())
                    .padding(.horizontal, 1)
                .onTapGesture {showAmenities.toggle()}
                    if showAmenities{
                        VStack(spacing:0){
                        ForEach(amenities, id:\.self){
                            amenity in
                            HStack{
                                if user.preferences.amenities.contains(amenity){
                                    Image(systemName: "checkmark.square").padding(.trailing)
                                } else {
                                    Image(systemName: "square").padding(.trailing)
                                }
                                Text(amenity)
                                Spacer()
                                
                            }.padding(.horizontal)
                            .padding(.top)
                            .contentShape(Rectangle())
                            .onTapGesture{
                                if user.preferences.amenities.contains(amenity){
                                    user.preferences.amenities = user.preferences.amenities.filter {$0 != amenity}
                                } else {
                                    user.preferences.amenities.append(amenity)
                                }
                            }
                            
                        }
                        }
                    }
                }.animation(.spring())
            }//
        }
            
            
            
            Spacer()
        }
        
        }
}
}
extension AnyTransition {
    static func moveAndScale(edge: Edge) -> AnyTransition {
        AnyTransition.move(edge: edge)
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

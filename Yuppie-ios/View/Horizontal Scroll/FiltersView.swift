
import SwiftUI

struct FiltersView: View {
    var Bedrooms = ["Studio", "1", "2", "3+"]
    @Binding var token: String
    @Binding var user : User
    @Binding var user_id: String
    @State var minDate: Date
    @State var maxDate: Date
    var Bathrooms = ["1", "2", "3"]
    @State var animals = false
    @State var gym = false
    @State var rooftop = false
    @State var balcony = false
    @State var airConditioning = false
    @State var doorman = false
    @Environment(\.colorScheme) var colorScheme
    var isExceeded = false
    var chipStack = [["Doorman","Pool","Gym","Rooftop"], ["Laundry", "Elevator"]]
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
        ScrollView{
        VStack{
        VStack{
            HStack{
                Text("Number of Bedrooms").fontWeight(.heavy)
                Spacer()
            }.padding(.horizontal,25)
            Picker(selection: $user.preferences.bedrooms, label:
                    Text(Bedrooms[user.preferences.bedrooms])
            ) {
                ForEach(0 ..< Bedrooms.count) {
                    Text(self.Bedrooms[$0])
                }
                .padding(1.0)
                }.pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal,25)
        
            HStack{
                Text("Number of Bathrooms").fontWeight(.heavy)
                Spacer()
            }.padding(.horizontal,25)
            Picker(selection: $user.preferences.bathrooms, label:
                    Text(Bathrooms[user.preferences.bathrooms])
            ) {
                ForEach(0 ..< Bathrooms.count) {
                    Text(self.Bathrooms[$0])
                }
                .padding(1.0)
            }.pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal,25)
            
            HStack{
                Text("The most I can pay is $\(priceFormat(price:user.preferences.price))").fontWeight(.heavy)
                Spacer()
            }.padding(.horizontal,25)
            Slider(value: $user.preferences.price, in: 1000...10000)
                .padding(.horizontal,25)
            VStack{
                HStack{
                    Text("Anticipated Move In Date").fontWeight(.heavy)
                    Spacer()
                    
                }.padding(.horizontal,25)
                DatePicker("Earliest Move In", selection: $minDate, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle()).padding(.horizontal,25)
            DatePicker("Latest Move In", selection: $maxDate, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle()).padding(.horizontal,25)
            HStack{
                Text("I can't live without").fontWeight(.heavy)
                Spacer()
            }.padding(.horizontal,25)
            }
            ScrollView{
                // Chips View...
                LazyVStack(alignment: .leading,spacing: 10){
                    
                    // Since Were Using Indices So WE Need To Specify Id....
                    ForEach(chipStack, id: \.self){
                        chips in
                    HStack{
                            ForEach(chips.indices,id: \.self){index in
                                Button(action:{
                                    if user.preferences.amenities.contains(chips[index]){
                                        user.preferences.amenities = user.preferences.amenities.filter {$0 != chips[index]}
                                    } else {
                                    user.preferences.amenities.append(chips[index])
                                    }
                                }){
                                Text(chips[index])
                                    .fontWeight(.semibold)
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    .padding(.vertical,10)
                                    .padding(.horizontal)
                                    .background(Capsule().stroke(colorScheme == .dark ? Color.white : Color.black,lineWidth: 1))
                                    .background(Capsule().fill(user.preferences.amenities.contains(chips[index]) ? Color.purple: (colorScheme == .dark ? Color.black : Color.white)))
                                    .lineLimit(1)
                                }
                            }
                    }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 3)
            // Border...
            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.0),lineWidth: 1.5))
            // TextEditor....
            
            

        .padding()
//
        }
            
            
            
            Spacer()
        }
        
        }.padding()
}
}

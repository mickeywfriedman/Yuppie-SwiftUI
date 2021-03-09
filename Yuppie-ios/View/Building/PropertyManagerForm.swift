import SwiftUI
import Combine

struct PropertyManagerForm : View {
    
    @Binding var token: String
    @Binding var user_id: String
    @Binding var user : User
    var building: Building
    @Binding var showForm: Bool
    @State private var keyboardHeight: CGFloat = 0
    @State private var MoveIn = Date()
    @State private var Apartment = 0
    @State private var Message = ""
    @State private var showPopUp = false
    @State private var amenityHours = false
    @State private var petPolicy = false
    @State private var additionalCharges = false
    @State private var localActivites = false
    @State private var Parking = false
    @State private var covidPolicies = false
    @State private var askString = ""
    @Environment(\.colorScheme) var colorScheme
    func sendEmail (Message: String, Apartment: String, userID: String, building: Building, moveIn:Date){
        self.user.contacted.append(building.id)
        let lead = Lead(
            message: Message,
            buildingId: building.id,
            user: user_id,
            propertyManager: building.propertyManager.id,
            propertyName: building.name,
            unitEnquired: Apartment,
            moveInDate: dateFormat(date: MoveIn)
        )
        guard let encoded = try? JSONEncoder().encode(lead) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "http://18.218.78.71:8080/leads") else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        print(token)
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(response)
        }.resume()
    }
    func Apartments () -> [String]{
        var result = [""]
        for apartment in building.units {
            result.append(apartment.number)
        }
        result.removeFirst()
        return result
    }
    func dateFormat(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    var body : some View{
        var message = "Hello my name is \(user.firstName) and I am interested in Unit \(Apartments()[Apartment]) and would like to move in around \(dateFormat(date: MoveIn)). Can you tell me more about: \n\(self.amenityHours ? "-Amenity Hours\n": "")\(self.petPolicy ? "-Pet Policy\n": "")\(self.additionalCharges ? "-Additional Charges\n": "")\(self.localActivites ? "-Local Activities\n": "")\(self.covidPolicies ? "-Covid Policies\n": "")\(self.Parking ? "-Parking\n": "")"
        VStack(alignment: .center){
            Text("Contact Property").fontWeight(.heavy).font(.largeTitle)
                .padding(.vertical)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            HStack{
                Text("Ask About:").foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            Spacer()
            }
            HStack{
                if self.amenityHours { Button(action:{
                    self.amenityHours = !self.amenityHours
                    self.Message = message
                }) {
                    Text("Amenity Hours")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                        self.amenityHours = !self.amenityHours
                        self.Message = message
                    }) {
                        Text("Amenity Hours")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                }
                if self.petPolicy { Button(action:{
                    self.petPolicy = !self.petPolicy
                    self.Message = message
                }) {
                    Text("Pet Policy")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                            self.petPolicy = !self.petPolicy
                            self.Message = message
                    }) {
                        Text("Pet Policy")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                    
                }
            }
            HStack{
                if self.additionalCharges { Button(action:{
                    self.additionalCharges = !self.additionalCharges
                    self.Message = message
                }) {
                    Text("Additional Charges")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                            self.additionalCharges = !self.additionalCharges
                            self.Message = message
                    }) {
                        Text("Additional Charges")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                }
                if self.localActivites { Button(action:{
                    self.localActivites = !self.localActivites
                    self.Message = message
                }) {
                    Text("Local Activities")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{self.localActivites = !self.localActivites}) {
                        Text("Local Activities")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                    
                }
            }
            HStack{
                if self.Parking { Button(action:{
                    self.Parking = !self.Parking
                    self.Message = message
                }) {
                    Text("Parking")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                        self.Parking = !self.Parking
                        self.Message = message
                    }) {
                        Text("Parking")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                }
                if self.covidPolicies { Button(action:{
                    self.covidPolicies = !self.covidPolicies
                    self.Message = message
                }) {
                    Text("Covid Policy")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{self.covidPolicies = !self.covidPolicies}) {
                        Text("Covid Policy")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                    
                }
            }
            
            HStack{
                Text("Select Apartment")
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                Spacer()
                Picker(selection: $Apartment, label:
                        Text(Apartments()[Apartment])
            ) {
                ForEach(0 ..< Apartments().count) {
                    Text(self.Apartments()[$0])
                }
                .padding(1.0)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }.pickerStyle(MenuPickerStyle())
                .onReceive([self.Apartment].publisher.first()) { value in
                    self.Message = message
                 }
            }
            DatePicker("Move In Date", selection: $MoveIn, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .onReceive([self.MoveIn].publisher.first()) { value in
                    self.Message = message
                 }
            TextEditor(text:$Message)
                .border(Color.black, width: 2)
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight:300, maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(.bottom, keyboardHeight)
                .onReceive(Publishers.keyboardHeight) {
                    self.keyboardHeight = $0
                    message = Message
                }
            Button(action: {
                self.showPopUp = true
                sendEmail(Message: Message, Apartment: Apartments()[Apartment], userID: user_id, building: building, moveIn: MoveIn)
            }) {
                Text("Send Message").font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
        }.padding().edgesIgnoringSafeArea([.top, .bottom])
        .onTapGesture {
            message = Message
            self.endTextEditing()
        }
        if $showPopUp.wrappedValue {
                VStack(alignment: .center) {
                    Text("Message sent").fontWeight(.heavy)
                    Text("The Property manager should reach out to you shortly.")
                }
        }
    }
}


extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { _ in CGFloat(300) }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

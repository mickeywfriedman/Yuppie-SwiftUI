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
    @State private var showPopUp = false
    @State private var amenityHours = false
    @State private var petPolicy = false
    @State private var additionalCharges = false
    @State private var localActivites = false
    @State private var Parking = false
    @State private var covidPolicies = false
    @State private var email = ""
    @State var message = ""
    @Environment(\.colorScheme) var colorScheme
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color.white]
    var gradient2 = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    func verifyEmail (){
        self.user.email = email
        let post_request = Email(
            email: email
        )
        guard let encoded = try? JSONEncoder().encode(post_request) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "http://18.218.78.71:8080/emails/request/\(user_id)") else {
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
    func loadUser() {
        if (self.token != "") {
            guard let user_url = URL(string: "http://18.218.78.71:8080/users/\(self.user_id)") else {
                print("Your API end point is Invalid")
                return
            }
            var user_request = URLRequest(url: user_url)
            user_request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: user_request) { data, response, error in
                if let data = data {
                    print(self.token)
                    print(self.user_id)
                    if let urlresponse = try? JSONDecoder().decode(userResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.user = urlresponse.data
                            print("success")
                            print(self.user)
                        }
                        return
                    }
                    
                }
            }.resume()
        }
        }
    func loadMessage() -> Void {
        if self.showPopUp{
            self.message = "Message sent. The Property Manager should reach out to you shortly."
        } else{
        self.message = "Hello my name is \(user.firstName) and I am interested in Unit \(Apartments()[Apartment]) and would like to move in around \(dateFormat(date: MoveIn)). Can you tell me more about: \n\(self.amenityHours ? "-Amenity Hours\n": "")\(self.petPolicy ? "-Pet Policy\n": "")\(self.additionalCharges ? "-Additional Charges\n": "")\(self.localActivites ? "-Local Activities\n": "")\(self.covidPolicies ? "-Covid Policies\n": "")\(self.Parking ? "-Parking\n": "")"
        }
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
        if user.emailVerified == false {
            if user.email == ""{
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                VStack(alignment: .center){
                    
                    VStack(spacing: 45){
                        
                        LottieView(name: "lease", loopMode: .loop)
                                    .frame(width: 200, height: 200)

                    }
                    
                    .background(
                    
                        LinearGradient(gradient: .init(colors: [Color("pgradient1"),Color("pgradient2")]), startPoint: .top, endPoint: .bottom)
                    )
                    .clipShape(Circle())
                    .padding(15)
                    .background(Color("power1").opacity(0.7))
                    .clipShape(Circle())
                    .padding(15)
                    .padding(.bottom, 15)
                    .shadow(color: Color("Chat_color").opacity(0.2), radius: 6, x:3, y: 5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                    .offset(y: 80)
                    .padding(.bottom, 20)
                Text("Enter your email to begin messaging with Porperty Managers.")
                    .foregroundColor(Color.white)
                    .offset(y:80)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                TextField("Email", text: self.$email )
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color("pgradient1"))
                    .clipShape(Capsule())
                    .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                    .offset(y:80)
                    .padding(.bottom, 20)
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color("Chat_color"))
                        .cornerRadius(30.0)
                        .padding(.bottom, 20)
                        .onTapGesture {
                            verifyEmail()
                        }
                        .offset(y:80)
                }.padding()
                })
            } else {
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                VStack(alignment: .center){
                    
                    VStack(spacing: 45){
                        
                        LottieView(name: "thankyou", loopMode: .loop)
                                    .frame(width: 200, height: 200)
                                    

                    }.padding(.bottom, 20)
                    .offset(y: 80)
                    
                    Text("Please click on the email verification link we sent to your email.")
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .offset(y: 80)
                        .padding(.bottom, 20)
                        .font(.custom("Futura", size: 18))
                    Text("Refresh")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color("Chat_color"))
                        .cornerRadius(30.0)
                        .padding(.bottom, 20)
                        .offset(y: 80)
                        .font(.custom("Futura", size: 18))
                        .onTapGesture {
                            loadUser()
                        }
                    
                    Text("Enter Another Email")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2), height: 50)
                        .background(Color("Chat_color"))
                        .cornerRadius(30.0)
                        .onTapGesture{
                            self.email = ""
                            self.user.email = ""
                        }
                        .offset(y: 80)
                        
                }.padding()
                })}
        } else {
            if user.contacted.contains(building.id){
                Text("Message sent. The Property Manager should reach out to you shortly.").padding().foregroundColor(.black)
            } else {
        VStack(alignment: .center){
            Text("Contact Property").fontWeight(.heavy).font(.largeTitle)
                .padding(.vertical)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .onAppear(perform: {
                    loadMessage()
                })
            HStack{
                Text("Ask About:").foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            Spacer()
            }
            HStack{
                Text("Amenity Hours")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                    .background(self.amenityHours ? Color.purple: Color.gray)
                    .cornerRadius(30.0)
                    .onTapGesture {
                        self.amenityHours.toggle()
                        loadMessage()
                    }
                Text("Pet Policy")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                    .background(self.petPolicy ? Color.purple: Color.gray)
                    .cornerRadius(30.0)
                    .onTapGesture {
                        self.petPolicy.toggle()
                        loadMessage()
                    }
            }
            HStack{
                Text("Additional Charges")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                    .background(self.additionalCharges ? Color.purple: Color.gray)
                    .cornerRadius(30.0)
                    .onTapGesture {
                        self.additionalCharges.toggle()
                        loadMessage()
                    }
                Text("Local Activities")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                    .background(self.localActivites ? Color.purple: Color.gray)
                    .cornerRadius(30.0)
                    .onTapGesture {
                        self.localActivites.toggle()
                        loadMessage()
                    }
            }
            HStack{
                Text("Parking")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                    .background(self.Parking ? Color.purple: Color.gray)
                    .cornerRadius(30.0)
                    .onTapGesture {
                        self.Parking.toggle()
                        loadMessage()
                    }
                Text("Covid Policy")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                    .background(self.covidPolicies ? Color.purple: Color.gray)
                    .cornerRadius(30.0)
                    .onTapGesture {
                        self.covidPolicies.toggle()
                        loadMessage()
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
                    loadMessage()
                 }
            }
            DatePicker("Move In Date", selection: $MoveIn, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .onReceive([self.MoveIn].publisher.first()) { value in
                    if value != self.MoveIn{
                    loadMessage()
                    }
                 }
            TextEditor(text:$message)
                .border(Color.black, width: 2)
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight:300, maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .onReceive(Publishers.keyboardHeight) {
                    self.keyboardHeight = $0
                }
            Button(action: {
                self.showPopUp = true
                sendEmail(Message: message, Apartment: Apartments()[Apartment], userID: user_id, building: building, moveIn: MoveIn)
                self.endTextEditing()
            }) {
                Text("Send Message").font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
        }.padding().padding(.bottom, keyboardHeight).edgesIgnoringSafeArea([.top, .bottom])
        .onTapGesture {
            hideKeyboard()
        }
            }}
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

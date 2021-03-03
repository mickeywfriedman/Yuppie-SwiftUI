//
//  Verification.swift
//  Complex Curve
//
//  Created by Mickey Friedman on 02/10/1399 AP.
//




import SwiftUI
import PushNotifications

struct Verification_Payload: Codable {
    var phone: String
    var passcode: String
}



struct Verification: View {
    
    @State var code = ""
    @Binding var number: String
    @State var showBirthday = false
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    @State var showFirstLastName = false
    @State var value: CGFloat = 0
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    var gradient2 = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var isNumberValid: Bool {
        if code.count < 6 {
            return false
        }
        if code.count > 6 {
            return false
        }
        return true
    }
    
    @StateObject var serverData = UniversityModel()
    @StateObject var universityData = UniversityModel()
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    func receiveAuthInfo (){
        let payload = Verification_Payload(
            phone: self.number,
            passcode: self.code
        )
        guard let encoded = try? JSONEncoder().encode(payload) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: "http://18.218.78.71:8080/users/verify") else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let urlresponse = try? JSONDecoder().decode(authResponse.self, from: data) {
                    DispatchQueue.main.async {
                        let response = urlresponse.result
                       
                        self.token = response.access_token
                        self.user_id = response.user_id
                        self.needsAccount = response.needsAccount
                        print("success", self.token, self.user_id)
                        
                        let pushNotifications = PushNotifications.shared
                        pushNotifications.clearAllState {
                          print("Cleared all state!")
                        }
                        let tokenProvider = BeamsTokenProvider(authURL: "http://18.218.78.71:8080/authentication/notifications") { () -> AuthData in
                            let sessionToken = self.token
                            print(self.token, self.user_id, "pushnotifs")
                          let headers = ["Authorization": "Bearer \(sessionToken)"] // Headers your auth endpoint needs
                          let queryParams: [String: String] = [:] // URL query params your auth endpoint needs
                          return AuthData(headers: headers, queryParams: queryParams)
                        }

                        pushNotifications.setUserId(self.user_id, tokenProvider: tokenProvider, completion: { error in
                          guard error == nil else {
                              print(error.debugDescription)
                              return
                          }

                          print("Successfully authenticated with Pusher Beams")
                        })
                    }
                    return
                }
                
            }
        }.resume()
    }
    
      
   

    
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination:  FirstLastName(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showFirstLastName){
                //Birthday(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showBirthday)
                
                Text("")
            }
            
            
            VStack(spacing: 35){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                        .clipShape(CustomShapeOnboarding())
                       
                        
                    
                    
                    VStack{
                            
                            VStack(spacing: 45){
                                
                                Image(systemName: "checkmark")
                                    .font(.system(size: 70))
                                    .shadow(color: Color("Chat_color").opacity(0.2), radius: 6, x:3, y: 5)
                                    .foregroundColor(universityData.isConnected ? Color.white.opacity(0.6) : Color("power"))
                                    .frame(height: UIScreen.main.bounds.height / 9)

                            }
                            .padding(50)
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
                            .offset(y: -65)
                            
                        .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                        
                        Text("Enter the 6 digit code just texted to you.")
                            .foregroundColor(Color("Color1"))
                            .font(.custom("Futura", size: 18))
                            .offset(y: -65)
                            .offset(y: -self.value).animation(.spring()).onAppear{
                                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {(noti) in
                                    
                                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                    let height = value.height
                                    
                                    self.value = height/9
                                }
                                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {(noti) in
                                    
                                   
                                    
                                    self.value = 0
                                }
                            }
                        HStack(spacing: 15){
                            Spacer()
                            ZStack(alignment: .trailing){
                            TextField("Code", text: self.$code)
                                .keyboardType(.numberPad)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(Color("pgradient1").opacity(0.6))
                                .clipShape(Capsule())
                                .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                                .font(.custom("Futura", size: 18))
                                .offset(y: -35)
                                .offset(y: -self.value).animation(.spring()).onAppear{
                                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {(noti) in
                                        
                                        let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                        let height = value.height
                                        
                                        self.value = height/9
                                    }
                                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {(noti) in
                                        
                                       
                                        
                                        self.value = 0
                                    }
                                }
                                
                            Spacer()
                    
                        .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                        .offset(y: 30)
                        
                        if !self.code.isEmpty {
                            if !self.isNumberValid {
                                Text("6 characters")
                                    .font(.custom("Futura", size: 16))
                                    .foregroundColor(Color("Color1"))
                                    .offset(y: -35)
                                    .padding(.trailing, 20)
                                        .padding(.horizontal, 10)
                                    .offset(y: -self.value).animation(.spring()).onAppear{
                                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {(noti) in
                                            
                                            let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                            let height = value.height
                                            
                                            self.value = height/7
                                        }
                                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {(noti) in
                                            self.value = 0
                                        }
                                    }
                            }else{
                                Text("👍")
                                    .font(.custom("Futura", size: 16))
                                    .foregroundColor(Color("Color"))
                                    .offset(y: -35)
                                    .padding(.trailing, 20)
                                        .padding(.horizontal, 10)
                                    .offset(y: -self.value).animation(.spring()).onAppear{
                                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {(noti) in
                                            
                                            let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                            let height = value.height
                                            
                                            self.value = height/7
                                        }
                                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {(noti) in
                                            self.value = 0
                                        }
                                    }
                            }
                        }
                            }
                        }
                        
                        Button(action: {
                            self.receiveAuthInfo()
                            self.didLogin = false
                            self.needsAccount = true
                            self.showFirstLastName.toggle()
                            
                        }) {
                            
                            Text("Verify")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 45)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                                .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                                .font(.custom("Futura", size: 18))
                        }
                        // disabling view when both textfields are empty...
                        .opacity(!self.isNumberValid  ? 0.65 : 1)
                        .disabled(!self.isNumberValid  ? true : false)
                        .offset(y: -self.value).animation(.spring()).onAppear{
                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {(noti) in
                                
                                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                let height = value.height
                                
                                self.value = height/9
                            }
                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) {(noti) in
                                
                               
                                
                                self.value = 0
                            }
                        }
                        
                        Spacer()
                        
                        
                    }
                    
                })
                .padding(.top,60)
                

            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
        
            ZStack{
                
                LinearGradient(gradient: .init(colors: gradient2), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.1)
                    .ignoresSafeArea(.all, edges: .top)
            }
        )
        .onTapGesture {
            hideKeyboard()
        }
    }
}


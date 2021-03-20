//
//  PhoneAuth.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 04/10/1399 AP.
//

import SwiftUI
import PushNotifications

struct PhoneAuth: View {
    
    @State var countryCode = "1"
    @State var number = ""
    @State var showVerification = false
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    @State var value: CGFloat = 0
    
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    var gradient2 = [Color("gradient4"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var isNumberValid: Bool {
        if number.count < 10 {
            return false
        }
        if number.count > 10 {
            return false
        }
        return true
    }
    
    @StateObject var universityData = UniversityModel()
    
 
    
      func cleanStr(str: String) -> String {
          return str.replacingOccurrences(of: "[.#$\\[/\\]];}", with: ",", options: [.regularExpression])
      }
      
      func toString(_ value: Any?) -> String {
        return String(describing: value ?? "")
      }
      
     public func send(_ sender: Any) {
      
 
        let parameters: [String: String] = ["phone": self.number]
          
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/users/request")! as URL)
          request.httpMethod = "POST"

         do {
             request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
             print(dump(toString(request.httpBody)))

            } catch let error {
                print(error)
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

             let task = URLSession.shared.dataTask(with: request as URLRequest) {
                 data, response, error in
                 
                   guard error == nil else {
                           return
                       }

                       guard let data = data else {
                           return
                       }

                       do {
                           //create json object from data
                           if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                              print(json)
                            
                           }

                          let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                                responseString as! String
                       } catch let error {
                           print(error)
                       }
             }
             task.resume()
         

      }

    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination: Verification(number: $number, token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showVerification) {
                
                Text("")
            }.transition(.moveAndFade)
            
            
            VStack(spacing: 35){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                        .clipShape(CustomShapeOnboarding())
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
                        
                    
                    
                    VStack(alignment:.center){
                            
                            VStack(spacing: 45){
                                
                                Image("small")
                                    .font(.system(size: 70))
                                    .shadow(color: Color("Chat_color").opacity(0.4), radius: 6, x:3, y: 5)
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
                            .shadow(color: Color("Chat_color").opacity(0.2), radius: 6, x:3, y: 5)
                            .padding(15)
                            .offset(y: -65)
                      
                            .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
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
                        
                        Text("Welcome To Nested")
                            .foregroundColor(Color("Color1"))
                            .font(.custom("Futura", size: 32))
                            .padding(.bottom,15)
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
                        
                        Text("Get Started by Entering Your Number")
                            .foregroundColor(Color("Color1"))
                            .font(.custom("Futura", size: 16))
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
                            ZStack(alignment: .trailing) {
                            TextField("Mobile Number", text: self.$number)
                                .keyboardType(.numberPad)
                                .foregroundColor(.white)
                                .font(.custom("Futura", size: 18))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(Color("pgradient1").opacity(0.6))
                                .clipShape(Capsule())
                                .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
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
                            if !self.number.isEmpty {
                                if !self.isNumberValid {
                                    Text("10 characters")
                                        .font(.custom("Futura", size: 16))
                                        .foregroundColor(Color("Color"))
                                        .offset(y: -65)
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
                                        .offset(y: -65)
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
                            Spacer()
                        }
                        .offset(y: 30)
                        Button(action: {
                            self.send((Any).self)
                            self.didLogin = false
                            self.needsAccount = true
                            self.showVerification.toggle()
                            
                            
                        }) {
                            
                            Text("Text Me")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 45)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                                .font(.custom("Futura", size: 18))
                                .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                                .offset(y:-15)
                        }
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
                        // disabling view when both textfields are empty...
                        .opacity(!self.isNumberValid  ? 0.65 : 1)
                        .disabled(!self.isNumberValid  ? true : false)
                        
                        Spacer()
                    }
                    
                })
                .padding(.top,60)
                

            }
            
            
        }.onTapGesture {
            hideKeyboard()
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
    }
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.slide
    }
}

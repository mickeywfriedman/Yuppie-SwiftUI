//
//  FirstLastName.swift
//  Complex Curve
//
//  Created by Mickey Friedman on 02/10/1399 AP.
//


import SwiftUI

struct FirstLastName: View {
    
    @State var countryCode = ""
    @State var number = ""
    @State var showProfilePicture = false
    @State var firstName: String = ""
    @State var lastName: String = ""
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    @State var value: CGFloat = 0
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    @StateObject var serverData = UniversityModel()
    

      func cleanStr(str: String) -> String {
          return str.replacingOccurrences(of: "[.#$\\[/\\]];}", with: ",", options: [.regularExpression])
      }
      
      func toString(_ value: Any?) -> String {
        return String(describing: value ?? "")
      }
    
    

      
      
      
     public func send(_ sender: Any) {
      
   let parameters: [String: String] = ["firstName": self.firstName, "lastName": self.lastName /*, "password2": self.password2*/]
          
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/users/"+self.user_id)! as URL)
          request.httpMethod = "PATCH"
        print(self.token)
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
 
        
        print("http://18.218.78.71:8080/users/"+self.user_id)
      
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
            
            NavigationLink(destination: ProfilePicture(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showProfilePicture) {
                
             
                Text("")
            }
            
            
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
                    
                    
                    VStack{
                            
                            VStack(spacing: 45){
                                
                                Image(systemName: "person")
                                    .font(.system(size: 70))
                                    .shadow(color: Color("Chat_color").opacity(0.2), radius: 6, x:3, y: 5)
                                    .foregroundColor(serverData.isConnected ? Color.white.opacity(0.6) : Color("power"))
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
                        .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                        
                        
                        Text("Enter your First and Last Name")
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

                            TextField("First Name", text: self.$firstName)
                              
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .font(.custom("Futura", size: 18))
                                .background(Color("pgradient1").opacity(0.6))
                                .clipShape(Capsule())
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
                                
                            Spacer()
                        }
                        .offset(y: 30)
                        .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                        HStack(spacing: 15){
                            Spacer()

                            TextField("Last Name", text: self.$lastName)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .font(.custom("Futura", size: 18))
                                .background(Color("pgradient1").opacity(0.6))
                                .clipShape(Capsule())
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
                                
                            Spacer()
                        }
                        .offset(y: 45)
                        .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                        Button(action: {
                            
                            self.send((Any).self)
                            
                            self.didLogin = false
                            self.needsAccount = true
                            
                            self.showProfilePicture.toggle()
                            
                        }) {
                            
                            Text("Next")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .font(.custom("Futura", size: 18))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 45)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                        }
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
                        // disabling view when both textfields are empty...
                        .opacity((self.firstName == "" || self.lastName == "") ? 0.65 : 1)
                        .disabled((self.firstName == "" || self.lastName == "") ? true : false)
                        
                        Spacer()
                        
                        
                    }
                    
                })
                .padding(.top,60)
                

            }
            
            
        }
        .onTapGesture {
            hideKeyboard()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
        
            ZStack{
                
                LinearGradient(gradient: .init(colors: gradient), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.1)
                    .ignoresSafeArea(.all, edges: .top)
            }
        )
    }
}


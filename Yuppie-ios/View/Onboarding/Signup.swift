//
//  Signup.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI

struct SignupView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var password2: String = ""
    @State var email: String = ""
    @State var showFirstLastName = false
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var random: Bool
    @Binding var token: String
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    @StateObject var serverData = UniversityModel()
    
    func send(_ sender: Any) {
    
        
 let parameters: [String: String] = ["email": self.email, "name": self.username, "password": self.password/*, "password2": self.password2*/]
        
    let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/authentication/signup")! as URL)
        request.httpMethod = "POST"
    
//    self.username = "\(self.username)"
//    self.password = "\(self.password)"
//    self.email = "\(self.email)"
    
       do {
           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
           print(request.httpBody)
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
                            print(json.keys)
                            
                            
                            //if let range = dict.range(of: "user_id") {
                                //let phone = snippet[range.upperBound...].trimmingCharacters(in: .whitespaces)
                                //print(phone) // prints "123.456.7891"
                           // }

                           // print(ability1)
                         }

                        let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                              responseString as! String
                              self.token = String(describing: responseString)
                     } catch let error {
                         print(error)
                     }
           }
           task.resume()
       

    }

    
    var body: some View {
        
        ZStack{
            
           
            NavigationLink(destination: FirstLastName(), isActive: self.$showFirstLastName) {
                
                Text("")
            }
            
            
            VStack(spacing: 35){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                        .clipShape(CustomShapeOnboarding())
                    
                    
                    VStack{
                        
                        
                        
                        Button(action: {serverData.isConnected.toggle()}, label: {
                            
                            VStack(spacing: 45){
                                
                                Image(systemName: "house")
                                    .font(.system(size: 70))
                                    .foregroundColor(serverData.isConnected ? Color.red.opacity(0.6) : Color("power"))
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
                            .background(Color("gradient2").opacity(0.7))
                            .clipShape(Circle())
                        })
                        .offset(y: -65)
                        .padding(.bottom,-65)
                        
                        
                        Text("Welcome to Yuppie").fontWeight(.heavy).font(.largeTitle)
                            .foregroundColor(Color.white)
                       
                        HStack(spacing: 15){
                            Spacer()

                            TextField("Email", text: self.$email)
                                .autocapitalization(.none)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                                
                            Spacer()
                        }
                        .offset(y: 30)
                        
                        HStack(spacing: 15){
                            Spacer()

                            SecureField("Password", text: self.$password)
                                .autocapitalization(.none)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                                
                            Spacer()
                        }
                        .offset(y: 45)
                        
                       
                        Button(action: {
                            self.send((Any).self)
                            
                           //self.random = true
                            self.showFirstLastName.toggle()
                            
                        }) {
                            
                            Text("Next")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 45)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                        }
                        // disabling view when both textfields are empty...
                        .opacity((self.email == "" || self.password == "") ? 0.65 : 1)
                        .disabled((self.email == "" || self.password == "") ? true : false).offset(y: 70)
                        
                        Spacer()
                        
                        
                    }
                    
                })
                .padding(.top,60)
                

            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
        
            ZStack{
                
                LinearGradient(gradient: .init(colors: gradient), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.1)
                    .ignoresSafeArea(.all, edges: .top)
            }
        ).navigationBarTitle("")
        .navigationBarHidden(true)
        
    }
    
}



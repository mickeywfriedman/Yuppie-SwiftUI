//
//  SelectAddress.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 04/10/1399 AP.
//

import SwiftUI

struct AddressView: View {
    
    @State var countryCode = ""
    @State var city = ""
    @State var unitNumber = ""
    @State var state = ""
    @State var index = 0
    @State var zipCode = ""
    @State var showTermsandConditions = false
    @State var address: String = ""
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]

    @StateObject var universityData = UniversityModel()
    
   
    

    
    
      func cleanStr(str: String) -> String {
          return str.replacingOccurrences(of: "[.#$\\[/\\]];}", with: ",", options: [.regularExpression])
      }
      
      func toString(_ value: Any?) -> String {
        return String(describing: value ?? "")
      }
      
     public func send(_ sender: Any) {

        let parameters: [String: String] = ["user" : self.user_id]
          
        let request = NSMutableURLRequest(url: NSURL(string: "buildings/5fdae6afedf9ef3d1f7c215c/tenants")! as URL)
          request.httpMethod = "POST"
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
        
        print(self.token, "AHAHAHAHAHAHHAAHAA")
             task.resume()
         

      }
    
    func printStatement(value: String){
        print(value)}
    
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination: Terms_Conditions(didLogin: $didLogin, needsAccount: $needsAccount, token: $token, user_id: $user_id), isActive: self.$showTermsandConditions) {
                
                Text("")
            }
            
            
            VStack(spacing: 35){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                        .clipShape(CustomShapeOnboarding())
                    
                    
                    VStack{
                        
                        Button(action: {universityData.isConnected.toggle()}, label: {
                            
                            VStack(spacing: 45){
                                
                                Image(systemName: "globe")
                                    .font(.system(size: 70))
                                    .foregroundColor(universityData.isConnected ? Color.red.opacity(0.6) : Color("power"))
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
                        
                        Text("Live in one of our buildings? Enter your street address.")
                            .foregroundColor(Color.white)
                        
                        Search_Bar(didLogin: $didLogin, needsAccount: $needsAccount, token: $token, user_id: $user_id)
                        
                        Button(action: {
                            print(self.token, "DDDDDDDDD")
                                        self.send((Any).self)
                                        self.showTermsandConditions.toggle()
                                        
                                    }) {
                                        
                                        Text("Search Apartments")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 45)
                                            .background(Color("pgradient1"))
                                            .clipShape(Capsule())
                                    }
                                    // disabling view when both textfields are empty...
                                    .opacity((self.address == "") ? 0.65 : 1)
                                    .disabled(( self.address == "") ? true : false).offset(y: 70)
                                    
           
                        
                    }
                    
                })
                

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
        )
    }
    
    struct AddressSearcher : View {
        @State var countryCode = ""
        @State var city = ""
        @State var unitNumber = ""
        @State var state = ""
        @State var index = 0
        @State var zipCode = ""
        @State var showCentralHomeView = false
        @State var address: String = ""
        @Binding var token: String
        @Binding var didLogin: Bool
        @Binding var needsAccount: Bool
        @Binding var user_id: String
        


        func cleanStr(str: String) -> String {
            return str.replacingOccurrences(of: "[.#$\\[/\\]];}", with: ",", options: [.regularExpression])
        }
        
        func toString(_ value: Any?) -> String {
          return String(describing: value ?? "")
        }
        public func send(_ sender: Any) {
            

            
        
            let parameters: [String: String] = ["user" : self.user_id]
              
            let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/buildings/5fdae6afedf9ef3d1f7c215c/tenants")! as URL)
              request.httpMethod = "POST"
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
        
        var body : some View{
            
            ZStack{
                NavigationLink(destination: CentralHomeView(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showCentralHomeView) {
                    
                    Text("")
                }
            }
        VStack{
            
            HStack(spacing: 15){
                Spacer()

                TextField("Street Address", text: self.$address)
                  
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color("pgradient1"))
                    .clipShape(Capsule())
                
//                            Button(action: {
//                                    withAnimation{buildingsData.showSheet.toggle()}}) {
//
//                                Text("Buildings")
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.white)
//                                    .padding(.vertical, 10)
//                                    .padding(.horizontal, 45)
//                                    .background(
//
//                                        LinearGradient(gradient: .init(colors: [Color("pgradient1"),Color("pgradient2")]), startPoint: .top, endPoint: .bottom)
//                                    )
//                                    .clipShape(Capsule())
//                            }
                    
                Spacer()
            }
            
           
            HStack(spacing: 15){
                Spacer()
               
                
                TextField("Unit #", text: self.$unitNumber)
                    // fixed Width...
                    .frame(width: 50)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color("pgradient1"))
                    .clipShape(Capsule())
                
                TextField("ZIP", text: self.$zipCode)
                    .keyboardType(.numberPad)
                    // fixed Width...
                    .frame(width: 50)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color("pgradient1"))
                    .clipShape(Capsule())
                
                TextField("City", text: self.$city)
                    // fixed Width...
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color("pgradient1"))
                    .clipShape(Capsule())
                
                TextField("State", text: self.$state)
                    // fixed Width...
                    .frame(width: 50)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(Color("pgradient1"))
                    .clipShape(Capsule())
                Spacer()
            }
            .offset(y: 30)
            
            Button(action: {
                self.send((Any).self)
                self.showCentralHomeView.toggle()
                
            }) {
                
                Text("Search Apartments")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 45)
                    .background(Color("pgradient1"))
                    .clipShape(Capsule())
            }
            // disabling view when both textfields are empty...
            .opacity((self.address == "") ? 0.65 : 1)
            .disabled(( self.address == "") ? true : false).offset(y: 70)
            
    
            
            
            Spacer()
            
        }
        }
    }
    }




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
    @State var showCentralHomeView = false
    @State var address: String = ""
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    @StateObject var buildingsData = AddressModel()
    @StateObject var universityData = UniversityModel()
    
   
    
    func printUserId() {
        
        print(self.user_id+"bip")
        print(self.token+"AUTHTOKEN")
        print(self.didLogin)
        
    }
    
    
      func cleanStr(str: String) -> String {
          return str.replacingOccurrences(of: "[.#$\\[/\\]];}", with: ",", options: [.regularExpression])
      }
      
      func toString(_ value: Any?) -> String {
        return String(describing: value ?? "")
      }
      
     public func send(_ sender: Any) {
      
        printUserId()
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
             task.resume()
         

      }

    
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination: CentralHomeView(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showCentralHomeView) {
                
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
                        
                        Text("Please enter your street address")
                            .foregroundColor(Color.white)
                        
                        
                        
                        HStack{
                            
                            Button(action: {
                                
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                                    
                                   self.index = 0
                                }
                                
                            }) {
                                
                                Text("Just Looking")
                                    .foregroundColor(self.index == 0 ? Color("gradient1") : .white)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 10)
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                
                            }.background(self.index == 0 ? Color.white : Color.clear)
                            .clipShape(Capsule())
                            
                            
                            Button(action: {
                                
                               withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                                   
                                  self.index = 1
                               }
                                
                            }) {
                                
                                Text("Yuppie Tenant")
                                    .foregroundColor(self.index == 1 ? Color("gradient1")  : .white)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 10)
                                    .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                                
                            }.background(self.index == 1 ? Color.white : Color.clear)
                            .clipShape(Capsule())
                            
                        }.background(Color.black.opacity(0.1))
                        .clipShape(Capsule())
                        .padding(.top, 25)
                        
                      
                        if self.index == 0{
                            Spacer()
                            
                            AddressSearcher(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id)
                        }
                        else{
                            
                            Spacer()
                            OnboardingTenant(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id)
                        }
 
                       
                        Spacer()
                        
                        
                    }
                    
                })
                .padding(.top,60)
                

            }
        
            BottomSheet_buildings(buildingsData: buildingsData)
            
            
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
        
        func printUserId() {
            
            print(self.user_id+"bip")
            print(self.token,"AUTHTOKEN")
            print(self.didLogin)
            
        }

        func cleanStr(str: String) -> String {
            return str.replacingOccurrences(of: "[.#$\\[/\\]];}", with: ",", options: [.regularExpression])
        }
        
        func toString(_ value: Any?) -> String {
          return String(describing: value ?? "")
        }
        public func send(_ sender: Any) {
            
            printUserId()
            
        
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
                self.didLogin = true
                self.needsAccount = false
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
    struct OnboardingTenant : View {
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
        
        @StateObject var buildingsData = AddressModel()
        @StateObject var universityData = UniversityModel()
        var body : some View{
        VStack{
            
                Button(action: {
                    withAnimation{buildingsData.showSheet.toggle()}
                }, label: {
                    
                    // CardViewOnboarding....
                    
                    CardViewOnboarding(University: buildingsData.currentUniversity,subTitle: "")
                        .background(BlurView())
                        .clipShape(Capsule())
                        .padding()
                    
                   
                }

                
                )
            
            Button(action: {
                self.didLogin = true
                self.needsAccount = false
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

        
            
            BottomSheet_buildings(buildingsData: buildingsData)

            
        }
        }
    }




//
//  University.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 05/10/1399 AP.
//

import SwiftUI

struct SelectUniversity: View {
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    
    
    @State var showAddress = false
    
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
      

        let parameters: [String: String] = ["university": "5feb477f79adebb6cf4ea243"]
          
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
        print(self.token)
             task.resume()
        

      }

    
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination: AddressView(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showAddress) {
                
                Text("")
            }
            
            VStack{
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                        .clipShape(CustomShapeOnboarding())
                    
                    
                    VStack{
                        
                        Button(action: {universityData.isConnected.toggle()}, label: {
                            
                            VStack(spacing: 15){
                                
                                LottieView(name: "school", loopMode: .loop)
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
                            .shadow(color: Color("Chat_color").opacity(0.6), radius: 5, x:5, y: 5)
                        })
                        .offset(y: -65)
                        .padding(.bottom,-65)
                        .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                        
                        Text("Select your University")
                            .foregroundColor(Color.white)
                            .font(.custom("Futura", size: 18))
                        Button(action: {
                            withAnimation{universityData.showSheet.toggle()}
                        }, label: {
                            
                            // CardViewOnboarding....
                            
                            CardViewOnboarding(University: universityData.currentUniversity,subTitle: "")
                                .background(BlurView())
                                .clipShape(Capsule())
                                .padding()
                                .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                            
                        }
                        
                        )
                        
                        Button(action: {
                            
                            self.send((Any).self)
                            self.didLogin = false
                            self.needsAccount = true
                            
                            self.showAddress.toggle()
                            
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
                        // disabling view when both textfields are empty...
                        
                        
                        Spacer()
                        
                        
                        Spacer()
                    }
                    
                })
                .padding(.top,60)

            }
            
            BottomSheet(universityData: universityData)
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


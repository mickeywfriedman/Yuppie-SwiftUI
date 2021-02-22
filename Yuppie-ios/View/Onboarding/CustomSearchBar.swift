//
//  CustomSearchBar.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 27/11/1399 AP.
//

import SwiftUI

struct CustomSearchBar: View {
    @ObservedObject var searchData: SearchUsers
    @State var rec = ""
    @State var show = false
    @State var showTermsandConditions = false
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var token: String
    @Binding var user_id: String
    
    func toString(_ value: Any?) -> String {
      return String(describing: value ?? "")
    }
    
    
    
    
    public func send(id: String) {
                

                
            
                let parameters: [String: String] = ["user" : self.user_id]
                  
                let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/buildings/\(id)/tenants")! as URL)
                  request.httpMethod = "POST"
               print(self.token, "HELLOOOOOOOO MICKEY")
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
        
        
        ZStack{ NavigationLink(destination: Terms_Conditions(didLogin: $didLogin, needsAccount: $needsAccount, token: $token, user_id: $user_id), isActive: self.$showTermsandConditions) {
            
            Text("")
        }
        }
        VStack(spacing: 0){
            VStack(spacing: 0){
            HStack(spacing: 12){
                
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.white)
                
                TextField("The Atelier...", text: $searchData.query)
                    .autocapitalization(.none)
                
            }.padding(.vertical, 10)
            .padding(.horizontal)
            
            if !searchData.searchedUser.isEmpty{
                ScrollView(.vertical, showsIndicators: true){
                    LazyVStack(alignment: .leading){
                        ForEach(searchData.searchedUser, id: \.id){user in
                            if ((user.address.streetAddress.lowercased()).contains(searchData.query)) == true{
                            VStack(alignment: .leading, spacing: 6){
                                    
                                        Text(user.name)
                                            .onTapGesture{
                                                print(self.token, "S:DFKJSD:LFKJSD:FLJSDF:DSLJF")
                                            searchData.query = user.name
                                            self.showTermsandConditions.toggle()
                                                self.send(id: user.id)
                                            //searchData.searchedUser.removeAll()
                                            
                                        }
                                Divider()
                            }.padding(.horizontal,35)
                            }else{
                                
                            }
                        }
                    }.frame(height: 100)
                    
                }
            }else{
                    VStack{
                    Text("We couldn't find your building😔")
                        .foregroundColor(Color.white)
                    Text("Submit your property manager below:")
                        .foregroundColor(Color.white)}
                        .offset(y: 35)
                    HStack(spacing: 15){
                        Spacer()
                        TextField("Code", text: self.$rec)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .background(Color("pgradient1"))
                            .clipShape(Capsule())
                            
                        Spacer()
                    }
                    .frame(height: 100)
                    .offset(y: 15)
            }
        }.background(Color("Color").opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius:20))
        .frame(height: 180)
        .padding()
    }
        
        Button(action: {
//                       
                        self.showTermsandConditions.toggle()
                        
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
//                    .opacity((self.address == "") ? 0.65 : 1)
//                    .disabled(( self.address == "") ? true : false).offset(y: 70)
                    
        
    }
    
    
}

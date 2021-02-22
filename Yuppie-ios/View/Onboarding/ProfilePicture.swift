//
//  ProfilePicture.swift
//  Complex Curve
//
//  Created by Mickey Friedman on 02/10/1399 AP.
//

import SwiftUI

struct ProfilePicture: View {
    
    @State var countryCode = ""
    @State var number = ""
    @State var MoveIn = Date()
    @State var showUniversity = false
    @State var showsDatePicker = false
    @State var images : [Data] = [Data()]
    @State var imagePicker = false
    @State var index = 0
    @State var showProfile = false
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    
    
    
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

        let profile = UIImage(data: self.images[0])!
        let imageData: Data = profile.jpegData(compressionQuality: 0.1) ?? Data()
        let imageStr: String = imageData.base64EncodedString()
        let paramStr: String = "images2=\(imageStr)"
        let paramData: Data = paramStr.data(using: .utf8) ?? Data()
        let parameters: [String: String] = ["image": imageStr]
          
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/images2")! as URL)
          request.httpMethod = "POST"
        
        
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
        print(imageStr+"THIS IS IMAGESTR")

           } catch let error {
               print(error)
           }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
            
            NavigationLink(destination: SelectUniversity(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showUniversity) {
                
                Text("")
            }
            
            VStack(spacing: 35){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                        .clipShape(CustomShapeOnboarding())
                    
                    
                    VStack{
                        
                        if self.images[0].count == 0{
                        
                        Button(action: {serverData.isConnected.toggle()}, label: {
                            
                            VStack(spacing: 45){
                                
                                Image(systemName: "camera")
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
                            .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                        })
                            
                        }else{
                            
                            Image(uiImage: UIImage(data: self.images[0])!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(serverData.isConnected ? Color.red.opacity(0.6) : Color("power"))
                                .frame(height: UIScreen.main.bounds.height / 4)
                                        


                        .clipShape(Circle())
                        .padding(15)
                        .clipShape(Circle())
                        .padding(15)
                        .background(Color("gradient2").opacity(0.7))
                        .clipShape(Circle())
                        .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                        
                    }
                    
                        
                        Text("Choose a Profile Picture")
                            .foregroundColor(Color.white)
                       
                        HStack(spacing: 15){
                            
                            Button(action: {self.index = 0
                                    self.imagePicker.toggle()}, label: {
                                
                                VStack(spacing: 45){
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 20))
                                        .foregroundColor(serverData.isConnected ? Color.red.opacity(0.6) : Color("power"))
                                        .frame(height: UIScreen.main.bounds.height / 16)

                                }
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
                                .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                            })
                            .padding(.bottom,-65)
                            
                        }.sheet(isPresented: self.$imagePicker) {
                            
                            ImagePickerOnboarding(showPicker: self.$imagePicker, imageData: self.$images[self.index])
                        }
                            
                            
                            
                        Button(action: {
                            self.send((Any).self)
                            self.didLogin = false
                            self.needsAccount = true
                            self.showUniversity.toggle()
                            
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
                        .offset(y: 70)
                        
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
            
        )
    }
    
    func verifyImages()->Bool{
        
        var status = true
        
        for i in self.images{
            
            if i.count == 0{
                
                status = false
            }
        }
        
        return status
    }
}

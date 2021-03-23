//
//  InstructionsApartmentSearcher.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 02/01/1400 AP.
//


import SwiftUI

struct InstructionsApartmentSearcher: View {
    

    @State var showVerification = false
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    @State var maxWidth = UIScreen.main.bounds.width - 100
    @State var offset: CGFloat = 0
    @Binding var showCard : Bool
    @State var buildingId : String
    @State var showInstructionsResidents = false
    
    
    
    func toString(_ value: Any?) -> String {
      return String(describing: value ?? "")
    }
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color.white, Color.white, Color("gradient1")]
    @StateObject var universityData = UniversityModel()
    
    
    func calculateWidth() -> CGFloat {
        let percent = offset / maxWidth
        return percent * maxWidth
        
    }
 
    func onChanged(value: DragGesture.Value){
        
        if value.translation.width > 0 && offset <= maxWidth - 65{
        offset = value.translation.width
        }
        
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(Animation.easeOut(duration: 0.3)){
            if offset > 180 {
                offset = maxWidth - 65
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                NotificationCenter.default.post(name:
                                                    Notification.Name("Success"), object: nil)
                    self.send((Any).self)
                    print(self.token)
                    self.didLogin = false
                                   self.needsAccount = true
                                   self.showInstructionsResidents.toggle()
                }
                
                
                
            }
            else {
                offset = 0
            }
        }
    }
      
    public func send(_ sender: Any) {
       let parameters: [String: Bool] = ["terms": true]
       let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/users/"+self.user_id)! as URL)
         request.httpMethod = "PATCH"
       print(self.token)
       request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        print(self.token)
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
        
        print(self.token, "Terms")
            task.resume()
        

     }
    
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination: InstructionsResidents(token: self.$token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id, showCard: self.$showCard, buildingId: ""), isActive: self.$showInstructionsResidents) {

                Text("")
            }
            
            
            VStack(){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    
                    
                    
                    VStack{
                        
                        Text("For Apartment Searchers ...")
                            .font(.custom("Futura", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack{
                       
                            
                    

                        
                            
                            VStack(alignment: .leading, spacing: 10, content: {
                              
                                
                                Text("Browse through different buildings and discover units on their map.")
                                    .frame(width: 180, alignment: .trailing)
                                    .foregroundColor(Color("Instructions_Color"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 30)
                                    .font(.custom("Futura", size: 18))
                                    
                            })
                            .padding(.horizontal, 30)
                            .frame(width: 177, height: 175)
                            
                            LottieView(name: "map", loopMode: .loop)
                                        .frame(width: 200, height: 200)
                        }
                        
                        HStack{
                        LottieView(name: "chat", loopMode: .loop)
                                    .frame(width: 200, height: 200)
                            
                    

                        
                            
                            VStack(alignment: .leading, spacing: 10, content: {
                              
                                
                                Text("Chat with current residents of those Nested communities")
                                    .frame(width: 180, alignment: .trailing)
                                    .foregroundColor(Color("Instructions_Color"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 30)
                                    .font(.custom("Futura", size: 18))
                                    
                            })
                            .padding(.horizontal, 30)
                            .frame(width: 177, height: 175)
                        }
                        
                        HStack{
                       
                            
                    

                        
                            
                            VStack(alignment: .leading, spacing: 10, content: {
                              
                                
                                Text("Reach out to the property managers directly in the app and move in with your friends!")
                                    .frame(width: 180, alignment: .trailing)
                                    .foregroundColor(Color("Instructions_Color"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 30)
                                    .font(.custom("Futura", size: 18))
                                    
                            })
                            .padding(.horizontal, 30)
                            .frame(width: 177, height: 175)
                            
                            LottieView(name: "lease", loopMode: .loop)
                                        .frame(width: 200, height: 200)
                        }
                        
                        
                        
                        
                        
                        
                                }
                        
                        
                        
                       
                       
                       
                       
                        Spacer()
                    
                    
                        
                        
                    }
                    
                )
                ZStack{
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                    
                    Text("Swipe for Residents")
                        .foregroundColor(Color.white)
                        .font(.custom("Futura", size: 18))
                        .padding(.leading, 30)
                    HStack{
                    Capsule()
                        .fill(Color("Chat_color"))
                        .frame(width:calculateWidth() + 65)
                        
                        Spacer(minLength: 0)
                        
                    }
                    
                    HStack{
                        ZStack{
                            Image(systemName: "chevron.right")
                            
                            Image(systemName: "chevron.right")
                                .offset(x: -10)
                        }.foregroundColor(.white)
                        .offset(x:5)
                        .frame(width:65, height: 65)
                        .background(Color("red"))
                        .clipShape(Circle())
                        .offset(x: offset)
                        .gesture(DragGesture().onChanged(onChanged(value:))
                                    .onEnded(onEnd(value:)))
                        
                        Spacer()
                    }
                }.frame(width: maxWidth, height: 65)
                .padding(.bottom)
        
                

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
}



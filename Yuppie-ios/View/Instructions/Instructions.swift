
//  Instructions.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 30/12/1399 AP.
//

import SwiftUI

struct InstructionsView: View {
    

    @State var showVerification = false
    @Binding var token: String
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var user_id: String
    @State var maxWidth = UIScreen.main.bounds.width - 100
    @State var offset: CGFloat = 0
    @Binding var showCard : Bool
    @State var buildingId : String
    @State var showInstructionsApartmentSearcher = false
    
    
    
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
                                   self.showInstructionsApartmentSearcher.toggle()
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
            
            NavigationLink(destination: InstructionsApartmentSearcher(token: self.$token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id, showCard: self.$showCard, buildingId: ""), isActive: self.$showInstructionsApartmentSearcher) {

                Text("")
            }
            
            
            VStack(){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    
                    ScrollView{
                    
                    VStack{
                        
                        LottieView(name: "city", loopMode: .loop)
                                    .frame(width: 750, height: 750)
                            .offset(y: -100)

                            
                            VStack(alignment: .center) {
                                Text("Welcome to Nested!")
                                    .font(.custom("Futura", size: 30))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                Text("Get started finding your next community.")
                                    .frame(width: 400, alignment: .center)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 30)
                                    .font(.custom("Futura", size: 18))
                                    
                            }
                            .padding(.horizontal, 30)
                            .offset(y: -300)
                            .multilineTextAlignment(.center)
                        
                                }.background(Color("Color").opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius:20))
                    .frame(height: UIScreen.main.bounds.height - 220)

                        Spacer()
                    
                    
                    }
                        
                    }
                    
                )
                ZStack{
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                    
                    Text("Here's how the App Works")
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



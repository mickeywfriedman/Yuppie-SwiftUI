//
//  File.swift
//  Pods
//
//  Created by Mickey Friedman on 10/10/1399 AP.
//

//
//  Signup.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI

struct LoginView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var password2: String = ""
    @State var email: String = ""
    @Binding var user_id: String
    @State var showCentralHomeView = false
    @State var showSignupView = false
    @Binding var didLogin: Bool
    @State private var authToken: String = UserDefaults.standard.string(forKey: "Token") ?? ""
    @Binding var needsAccount: Bool
    @Binding var token: String
    
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
        
 let parameters: [String: String] = ["email": self.email, "password": self.password/*, "password2": self.password2*/]
        
    let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/authentication/login")! as URL)
        request.httpMethod = "POST"
    
//    self.username = "\(self.username)"
//    self.password = "\(self.password)"
//    self.email = "\(self.email)"
    
       do {
           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
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

                            let values = json.values
                            
                            let stringDictionaries: [[String: String]] = json.map { dictionary in
                                var dict: [String: String] = [:]
                                json.forEach { (key, value) in dict[key] = "\(value)" }
                                return dict
                            }
                            let string_result = stringDictionaries[0].values
                            
                            
                            
                            let snippet = dump(toString(string_result))
                            
                            
                            
                        
                            
                            
                                
                            
                            let range = snippet.range(of: "user_id")
                            let myString = snippet[(range?.upperBound...)!].trimmingCharacters(in: .whitespaces)
                           
                            var str = "_<$abc$>_"
                            let pattern = "[^A-Za-z0-9]+"
                            let regex = try! NSRegularExpression(pattern: "([A-HK-PRSVWY][A-HJ-PR-Y])\\s?([0][2-9]|[1-9][0-9])\\s?([.])\\s?([_])\\s?[A-HJ-PR-Z]{3}", options: NSRegularExpression.Options.caseInsensitive)
                            let range1 = NSMakeRange(0, myString.count)
                            let modString = regex.stringByReplacingMatches(in: myString, options: [], range: range1, withTemplate: "XX")
                            let cleaned_user_id = cleanStr(str: modString)
                            let word = cleaned_user_id.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
                            
                            self.user_id = String(word.dropLast())
                            
                            let range_token = snippet.range(of: "access_token")
                             let my_access_token = snippet[(range_token?.lowerBound...)!].trimmingCharacters(in: .whitespaces)
                            
                            
                            
                            str = String(my_access_token.split(separator: ";")[0])
                            
                            let replace_slashes = str.replacingOccurrences(of: "\\", with: "")
                            
                            let replace_access_token = replace_slashes.replacingOccurrences(of: "access_token", with: "")
                            
                            let replace_quotations = replace_access_token.replacingOccurrences(of: "\"", with: "")
                            
                            self.token = replace_quotations.replacingOccurrences(of: "=", with: "")
                            

                            

                            
                            //let modString_token = regex.stringByReplacingMatches(in: _token, options: [], range: range1, withTemplate: "XX")
                            
                            
                           // let cleaned_token = cleanStr(str: modString_token)
                           //let word_token = cleaned_token.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
                            
                           // print(word_token, "D:LFKJDS:LKFJSD")
                            
                            
                            
                         }

                        let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                              responseString as! String
                      
                     } catch let error {
                       
                     }
           }
           task.resume()
       

    }

    
    var body: some View {
        
        ZStack{
           
           
            NavigationLink(destination: CentralHomeView(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showCentralHomeView) {
                
                Text("")
            }
            
            NavigationLink(destination: SignupView(user_id: $user_id, didLogin: $didLogin, needsAccount: $needsAccount, token: $token), isActive: self.$showSignupView) {
                
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
                        
                        
                        Text("Login to Yuppie").fontWeight(.heavy).font(.largeTitle)
                            .foregroundColor(Color.white)
                       
                        HStack(spacing: 15){
                            Spacer()

                            TextField("Email", text: self.$email )
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
                            
                            
                            self.didLogin = true
                            self.needsAccount = false
                            self.showCentralHomeView.toggle()
                            
                        }) {
                            
                            Text("Submit")
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
                        
                        Button(action: {
                            self.needsAccount = true
                            self.showSignupView.toggle()
                            
                        }) {
                            
                            Text("Not yet a member?")
                                .foregroundColor(.white)
                        
                        }
                        .padding(.top, 20)
                        
                        
                    }
                    
                })
                .padding(.top,160)
                

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



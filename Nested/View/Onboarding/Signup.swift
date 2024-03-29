

//
//  Signup.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI
import PushNotifications

struct SignupView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var password2: String = ""
    @State var email: String = ""
    @Binding var user_id: String
    @State var showFirstLastName = false
    @State var showLogin = false
    @Binding var didLogin: Bool
    @State private var authToken: String = UserDefaults.standard.string(forKey: "Token") ?? ""
    @Binding var needsAccount: Bool
    @Binding var token: String
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var isEmailValid: Bool {
        if email.count < 5 {
            return false
        }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        if password.count < 6 {
            return false
        }
        return true
    }
    
    
    @StateObject var serverData = UniversityModel()
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func cleanStr(str: String) -> String {
        return str.replacingOccurrences(of: "[.#$\\[/\\]];}", with: ",", options: [.regularExpression])
    }
    
    func toString(_ value: Any?) -> String {
      return String(describing: value ?? "")
    }
    
   

    
    
    
   public func send(_ sender: Any) {
  
        
 let parameters: [String: String] = ["email": self.email, "password": self.password/*, "password2": self.password2*/]
        
    let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/authentication/signup")! as URL)
        request.httpMethod = "POST"
    
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
                            let filename = getDocumentsDirectory().appendingPathComponent("index.txt")
                            do {
                                try (("userID:")+self.user_id).write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                                
                            } catch {
                                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                            }
                            
                            let range_token = snippet.range(of: "access_token")
                             let my_access_token = snippet[(range_token?.lowerBound...)!].trimmingCharacters(in: .whitespaces)
                            
                         
                            
                            str = String(my_access_token.split(separator: ";")[0])
                            
                            let replace_slashes = str.replacingOccurrences(of: "\\", with: "")
                            
                            let replace_access_token = replace_slashes.replacingOccurrences(of: "access_token", with: "")
                            
                            let replace_quotations = replace_access_token.replacingOccurrences(of: "\"", with: "")
                            
                            self.token = replace_quotations.replacingOccurrences(of: "=", with: "")
                            
                            let pushNotifications = PushNotifications.shared
                            pushNotifications.clearAllState {
                              print("Cleared all state!")
                            }
                            let tokenProvider = BeamsTokenProvider(authURL: "http://18.218.78.71:8080/authentication/notifications") { () -> AuthData in
                                let sessionToken = self.token
                                print(self.token, self.user_id, "pushnotifs")
                              let headers = ["Authorization": "Bearer \(sessionToken)"] // Headers your auth endpoint needs
                              let queryParams: [String: String] = [:] // URL query params your auth endpoint needs
                              return AuthData(headers: headers, queryParams: queryParams)
                            }

                            pushNotifications.setUserId(self.user_id, tokenProvider: tokenProvider, completion: { error in
                              guard error == nil else {
                                  print(error.debugDescription)
                                  return
                              }

                              print("Successfully authenticated with Pusher Beams")
                            })
                            
                            do {
                                try (self.user_id+self.user_id+("token_id:")+self.token ).write(to: filename, atomically: true, encoding: String.Encoding.utf8)
                                
                            } catch {
                                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
                            }

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
           
           
            NavigationLink(destination: FirstLastName(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showFirstLastName) {
                
                Text("")
            }
            NavigationLink(destination: LoginView(user_id: $user_id, didLogin: $didLogin, needsAccount: $needsAccount, token: $token), isActive: self.$showLogin) {
                
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
                            .padding(15)
                            
                            .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                        })
                        .offset(y: -65)
                        .padding(.bottom,-65)
                        
                        
                        Text("Welcome to Yuppie").fontWeight(.heavy).font(.largeTitle)
                            .foregroundColor(Color.white).font(.custom("Futura", size: 20))
                       
                        HStack(spacing: 15){
                            Spacer()
                            ZStack(alignment: .trailing) {
                            TextField("Email", text: self.$email )
                                .autocapitalization(.none)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                                
                            
                            if !self.email.isEmpty {
                                if !self.isEmailValid {
                                    Text("Invalid email")
                                    .foregroundColor(Color("Color"))
                                    .padding(.trailing, 20)
                                        .padding(.horizontal, 10)
                                }
                            }
                            }
                                
                            Spacer()
                        }
                        .offset(y: 30)
                        .animation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5))
                        
                        HStack(spacing: 15){
                            Spacer()
                            ZStack(alignment: .trailing) {
                            SecureField("Password", text: self.$password)
                                .autocapitalization(.none)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                              
                            
                            if !self.password.isEmpty {
                                if !self.isPasswordValid {
                                    Text("Min. 6 characters")
                                        .foregroundColor(Color("Color"))
                                        .padding(.trailing, 20)
                                            .padding(.horizontal, 10)
                                }
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
                            self.showFirstLastName.toggle()
                            
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
                            self.showLogin.toggle()
                            
                        }) {
                            
                            Text("Already a member?")
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



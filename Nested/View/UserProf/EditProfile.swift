//
//  EditProfile.swift
//  Nested
//
//  Created by Ryan Cao on 4/26/21.
//

import SwiftUI

struct EditProfile: View {
    @Binding var user : User
    @State var token : String
    @State var saved = false
    @State var firstName : String
    @State var lastName : String
    @State var email : String
    @State var profilePicture : String
    @State var imagePicker = false
    @State var images : [Data] = [Data()]
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
    func PatchProfile (){
        self.saved = true
        self.user.firstName = firstName
        self.user.lastName = lastName
        self.user.profilePicture = profilePicture
        if email != user.email{
            user.email = email
            let parameters: [String: Any] = ["firstName": self.user.firstName, "lastName": self.user.lastName, "email": self.user.email]
        } else {
            let parameters: [String: String] = ["firstName": self.user.firstName, "lastName": self.user.lastName]
        }
        if images[0].count != 0 {
            send((Any).self)
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                loadUser()
            }
        }
        let parameters: [String: String] = ["firstName": self.user.firstName, "lastName": self.user.lastName, "email": self.user.email]
        guard let url = URL(string: "http://18.218.78.71:8080/users/\(user.id)") else {
            print("Your API end point is Invalid")
            return
        }
        var request = URLRequest(url: url)
        do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
       } catch let error {
           print(error)
       }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(response)
        }.resume()
        
    }
    func loadUser() {
        if (self.token != "") {
            guard let user_url = URL(string: "http://18.218.78.71:8080/users/\(self.user.id)") else {
                print("Your API end point is Invalid")
                return
            }
            var user_request = URLRequest(url: user_url)
            user_request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: user_request) { data, response, error in
                if let data = data {
                    if let urlresponse = try? JSONDecoder().decode(userResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.user = urlresponse.data
                        }
                        return
                    }
                    
                }
            }.resume()
        }
        }
    var body: some View {
        VStack{
            if images[0].count != 0 {
            Image(uiImage: UIImage(data: self.images[0])!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .background(Color("Color1"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
            } else{
            ImageView(url: "\(profilePicture)")
            .frame(width: 100, height: 100)
            .background(Color("Color1"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
            }
            Text("Edit Profile Picture")
                .onTapGesture {
                    self.imagePicker.toggle()
                }
                .padding(.bottom)
            HStack{
                Text("First Name")
                Spacer()
                TextField("First Name", text: self.$firstName)
                    .multilineTextAlignment(.trailing)
                    .onTapGesture {
                        self.firstName = ""
                    }
            }.sheet(isPresented: self.$imagePicker) {
                ImagePickerOnboarding(showPicker: self.$imagePicker, imageData: self.$images[0])
            }
            HStack{
                Text("Last Name")
                Spacer()
                TextField("Last Name", text: self.$lastName)
                    .multilineTextAlignment(.trailing)
                    .onTapGesture {
                        self.lastName = ""
                    }
            }
            HStack{
                Text("Email")
                Spacer()
                TextField("Email", text: self.$email)
                    .multilineTextAlignment(.trailing)
                    .onTapGesture {
                        self.email = ""
                    }
            }
            Spacer()
            if saved {
                Text("Changes Saved")
            } else {
                Text("Save Changes")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15.0)
                    .onTapGesture {
                        PatchProfile()
                    }
            }
        }.padding()
    }
}

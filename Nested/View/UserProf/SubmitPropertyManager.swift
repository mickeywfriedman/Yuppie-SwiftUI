//
//  SubmitPropertyManager.swift
//  Nested
//
//  Created by Ryan Cao on 4/15/21.
//

import SwiftUI

struct SubmitPropertyManager: View {
    @State var submitted = false
    @State var token: String
    @State var companyName = ""
    @State var address = ""
    @State var contactName = ""
    @State var contactPhone = ""
    @State var contactEmail = ""
    func sendMessage (){
        let message = """
Property Manager details
Address: \(address)
Company: \(companyName)
Contact Name: \(contactName)
Contact Phone: \(contactPhone)
contactEmail: \(contactEmail)
"""
        let parameters: [String: String] = ["message" : message]
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/recommendations")! as URL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

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
        if submitted{
            Text("Thank you for submitting your property manager.").padding()
        } else {
        VStack(alignment: .center){
            Text("Submit Property").fontWeight(.heavy).font(.largeTitle)
                .padding(.bottom)
            VStack{
                TextField("Address", text: self.$address)
                Divider()
            }
            VStack{
                TextField("Property Manager Company", text: self.$companyName)
                Divider()
            }
            VStack{
                TextField("Property Manager Name", text: self.$contactName)
                Divider()
            }
            VStack{
                TextField("Property Manager Phone", text: self.$contactPhone)
                Divider()
            }
            VStack{
                TextField("Property Manager Email", text: self.$contactEmail)
                Divider()
            }
            Text("Submit")
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
                .onTapGesture {
                    self.submitted = true
                    sendMessage()
                }
            Spacer()
        }.padding()
        }
    }
}


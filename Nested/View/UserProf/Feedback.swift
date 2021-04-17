//
//  Feedback.swift
//  Nested
//
//  Created by Ryan Cao on 4/15/21.
//

import SwiftUI
import Combine

struct Feedback: View {
    @State var message = ""
    @State var token : String
    @State var submitted = false
    func sendMessage (){
        let parameters: [String: String] = ["message" : message]
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/feedback")! as URL)
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
        if submitted {
            Text("Thank you for your feedback.")
        } else {
        Text("Please tell us how we can improve")
        TextEditor(text:$message)
            .border(Color.black, width: 2)
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight:300, maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
        Button(action: {
            self.submitted = true
            sendMessage()
        }) {
            Text("Submit Feedback").font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                .background(Color.blue)
                .cornerRadius(15.0)
        }
        }
            }
}


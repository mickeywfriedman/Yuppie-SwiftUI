//
//  HomeModel.swift
//  Global Chat
//
//  Created by Balaji on 12/09/20.
//

import SwiftUI

class ChatModel: ObservableObject{
    var user_id: String!
    var tenant_id: String!
    @Published var txt = ""
    @Published var msgs : [Message1] = []
    @Published var msgs1 : [Messages] = []
    @AppStorage("current_user") var user = ""
    init() {
        loadMessageData()
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
    
    func toString(_ value: Any?) -> String {
      return String(describing: value ?? "")
    }
    
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                //print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func onAppear(){
        
        // Checking whether user is joined already....
        
        if user == ""{
            // Join Alert...
            
            UIApplication.shared.windows.first?.rootViewController?.present(alertView(), animated: true)
        }
    }
    
    func alertView()->UIAlertController{
        
        let alert = UIAlertController(title: "Join Chat !!!", message: "Enter Nick Name", preferredStyle: .alert)
        
        alert.addTextField { (txt) in
            txt.placeholder = "eg Kavsoft"
        }
        
        let join = UIAlertAction(title: "Join", style: .default) { (_) in
            
            // checking for empty click...
            
            let user = alert.textFields![0].text ?? ""
            
            if user != ""{
                
                self.user = user
                return
            }
            
            // repromiting alert view...
            
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        }
        
        alert.addAction(join)
        
        return alert
    }
    
    func loadMessageData() {
        
        let url_file = self.getDocumentsDirectory().appendingPathComponent("index.txt")

                do {
                    let input = try String(contentsOf: url_file)
                    
                    let tenant_id = String(input[0..<24])
                    print(tenant_id)
                    let length = input.count
                    print(length)
                    let range = input.range(of: "token_id:")
                     let myString = input[(range?.lowerBound...)!].trimmingCharacters(in: .whitespaces)
                   
                    let token = input.substring(fromIndex: 57)
                    print (token, "FUCK")
                    
                    guard let url = URL(string: "http://18.218.78.71:8080/conversations/users/\(tenant_id)") else {
                        print("Your API end point is Invalid")
                        return
                    }
                    var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.httpMethod = "GET"
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                            //print(data)
                            let dataString = String(data: data, encoding: .utf8)
                            print(dataString)
                            if let response = try? JSONDecoder().decode(messageResponse.self, from: data) {
                                DispatchQueue.main.async {
                                    self.msgs = response.data.messages
                                }
                                return
                            }else {
                                print("fuck")
                            }
                        }
                    }.resume()
                } catch {
                    print(error.localizedDescription)
                }
        }

    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""

        for _ in 0 ..< length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }

        return randomString
    }
    
    func dateFormat(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        return dateFormatter.string(from: date)
    }
    
    func writeMsg(){
        
        let url_file = self.getDocumentsDirectory().appendingPathComponent("index.txt")

                do {
                    let input = try String(contentsOf: url_file)
                    let tenant_id = String(input[0..<24])
                    let user_id = String(input[24..<48])
                    let length = input.count
                    let range = input.range(of: "token_id:")
                     let myString = input[(range?.lowerBound...)!].trimmingCharacters(in: .whitespaces)
                    let token = input.substring(fromIndex: 57)
                    let id = randomAlphaNumericString(length: 24)
                    let date = dateFormat(date: Date())
                    let message = Messages(id: id, sender: user_id, sentTime: date,  message: txt, type: 0)
                                
                    let message1 = Message1(id: id, sender: user_id, sentTime: date,  message: txt, type: 0)
                    
                    guard let encoded = try? JSONEncoder().encode(message) else {
                        print("Failed to encode order")
                        return
                    }
                    guard let url = URL(string: "http://18.218.78.71:8080/conversations/users/\(tenant_id)") else {
                        print("Your API end point is Invalid")
                        return
                    }
                    var request = URLRequest(url: url)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpMethod = "POST"
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpBody = encoded
                    URLSession.shared.dataTask(with: request) {data, response, error in print(response)}.resume()

                    self.msgs.append(message1)
                    
                    self.txt = ""
                  }catch {
                        print(error.localizedDescription)
                    }
        
        
    }
        
}
extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

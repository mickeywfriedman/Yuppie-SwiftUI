//
//  ChatModel.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 19/11/1399 AP.
//

import SwiftUI

class ChatModel: ObservableObject{
    var user_id: String!
    var tenant_id: String!
    @Published var txt = ""
    @Published var msgs : [ReceivedMessages] = []
    @Published var msgs1 : [SentMessage] = []
    @AppStorage("current_user") var user = ""
    
    // For Brendan
    init() {
        loadMessageData()
    }
    
    deinit {
      NotificationCenter.default
       .removeObserver(self, name: NSNotification.Name ("com.messages." + self.tenant_id), object: nil) }
    
    
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
    @objc func receivedMessageNotif(_ notification: Notification){
        let message = notification.object as! ReceivedMessages
        self.msgs.append(message)
        //if statement 
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
    
    
    func loadMessageData() {
        
        let url_file = self.getDocumentsDirectory().appendingPathComponent("index.txt")

                do {
                    let input = try String(contentsOf: url_file)
                    //test tenant id
                    let tenant_id = String(input[0..<24])
                    self.tenant_id = tenant_id
                    addObserver()
                    //test token
                    let token = input.substring(fromIndex: 57)
                    // Get messages with tenant
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
                                if let response = try? JSONDecoder().decode(messageResponse.self, from: data) {
                                    DispatchQueue.main.async {
                                        self.msgs = response.data.messages
                                    }
                                    return
                                }
                            }
                        }.resume()
                    } catch {
                        print(error.localizedDescription)
                    }
            }
    
    func addObserver() {
        NotificationCenter.default
                          .addObserver(self,
                                       selector:#selector(receivedMessageNotif(_:)),
                                       name: NSNotification.Name ("com.messages." + self.tenant_id),
                         object: nil)
    }

    func writeMsg(){
        
        let url_file = self.getDocumentsDirectory().appendingPathComponent("index.txt")

                do {
                    //test tenant id
                    let input = try String(contentsOf: url_file)
                    let tenant_id = String(input[0..<24])
                    //test user id
                    let user_id = String(input[24..<48])
                    //test token
                    let token = input.substring(fromIndex: 57)
                    let id = randomAlphaNumericString(length: 24)
                    let date = dateFormat(date: Date())
                    let message = SentMessage(id: id, sender: user_id, sentTime: date,  message: txt, type: 0)
                                
                    let received_messages = ReceivedMessages(id: id, sender: user_id, sentTime: date,  message: txt, type: 0)
                   
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

                    self.msgs.append(received_messages)
                    
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

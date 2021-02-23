//
//  ChatRow.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 19/11/1399 AP.
//

import SwiftUI

struct ChatRow: View {
    
    @Binding var token: String
    @Binding var user_id: String
    @Binding var tenant_id: String
    @Binding var tenant_prof: String
    @State private var user = TestData.user
    var chatData : ReceivedMessages
    
    func print_user_id(){
        print(user_id)
    }
    
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    
    
    func loadUser() {
        if (token != "") {
        guard let user_url = URL(string: "http://18.218.78.71:8080/users/\(user_id)") else {
                print("Your API end point is Invalid")
                return
            }
            var user_request = URLRequest(url: user_url)
            user_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: user_request) { data, response, error in
                if let data = data {
                    if let urlresponse = try? JSONDecoder().decode(userResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.user = urlresponse.data
                            print("success")
                            print(self.user)
                        }
                        return
                    }
                    
                }
            }.resume()
        }
        }
    

    var body: some View {
        
        
        HStack(spacing: 15){
            
       
            
            if chatData.sender != self.user_id{
                ProfilePictureChat(token: $token, user_id: $user_id, tenant_id: $tenant_id, tenant_prof: $tenant_prof, name: chatData.sender)
                VStack(alignment: chatData.sender == self.user_id ? .trailing : .leading, spacing: 5, content: {
                    Text(chatData.message)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Chat_color"))
                    .clipShape(ChatBubble(myMsg: chatData.sender == self.user_id))
                    
                    Text(dateFormat(string: chatData.sentTime), style: .time)//change back
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(chatData.sender != self.user_id ? .leading : .trailing , 10)
                }
                )
            }
            
            if chatData.sender == self.user_id{
                Spacer(minLength: 0)}
            if chatData.sender == self.user_id{
                VStack(alignment: chatData.sender == self.user_id ? .trailing : .leading, spacing: 5, content: {
                    
                    Text(chatData.message)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.black.opacity(0.06))
                        .clipShape(ChatBubble(myMsg: chatData.sender == self.user_id))
                    
                    Text(dateFormat(string: chatData.sentTime), style: .time)//change back
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(chatData.sender != self.user_id ? .leading : .trailing , 10)
                }
                
                )
                ProfilePictureChat(token: $token, user_id: $user_id, tenant_id: $tenant_id, tenant_prof: $user.profilePicture, name: chatData.sender)
            }
            
            if chatData.sender != self.user_id{Spacer(minLength: 0)}
        }.onAppear(perform: loadUser)
        .padding(.horizontal)
        // For SCroll Reader....
        .id(chatData.id)
    }
}

struct ProfilePictureChat : View {
    @Binding var token: String
    @Binding var user_id: String
    @Binding var tenant_id: String
    @Binding var tenant_prof: String
    
    var name : String
    @AppStorage("current_user") var user = ""
    
    var body: some View{
        
        URLImage(url: self.tenant_prof)
            .frame(width: 40, height: 40)
                .cornerRadius(20)

    }
}

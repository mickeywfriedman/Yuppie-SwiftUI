//
//  Inbox.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 03/10/1399 AP.
//
import SwiftUI

struct convoResponse: Decodable {
    var data : [FriendsChat]
}


struct FriendsChat: Hashable, Decodable, Identifiable{
    var user1 : String
    var user2: String
    var modifiedDate: String
    var id : String
}


struct Inbox : View {
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var selectedTab = "Chats"
    @Namespace var animation
    @Binding var token: String
    @Binding var user_id: String
    @State var convos : [FriendsChat] = []
    @Binding var user : User
    
    func loadMessageData() {
        
      
        guard let url = URL(string: "http://18.218.78.71:8080/conversations") else {
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
                            if let response = try? JSONDecoder().decode(convoResponse.self, from: data) {
                                DispatchQueue.main.async {
                                    self.convos = response.data
                                }
                                return
                            }
                        }
                    }.resume()
                
        }
    
    var body: some View{
        
        VStack(spacing: 0){
            
            VStack{
                
                ZStack{
                    
                    HStack{
                        
                        Button(action: {}, label: {
                            
                            Image(systemName: "")
                                .font(.system(size: 22))
                        })
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {}, label: {
                            
                            Image(systemName: "")
                                .font(.system(size: 22))
                        })
                    }
                    
                    Text("Inbox")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding()
                .padding(.top,edges!.top)
                .foregroundColor(.white)
                
                
               
            }
            .padding(.bottom)
            .background(Color("Chat_color"))
            .clipShape(CurvedCorner(corner: .bottomLeft, size: 65))
            .clipShape(CurvedCorner(corner: .bottomRight, size: 65))
            
            ZStack{
                
                Color("top")
                
                Color("bg")
                    .clipShape(CurvedCorner(corner: .topRight, size: 65))
                 
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    VStack(spacing: 20){
                        
                        HStack{
                            
                            Text("All Chats")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer(minLength: 0)
                            
                           
                        }
                        .padding([.horizontal,.top])
                        
                      
                            
                            // Group Name..
                            HStack{
                                
                                Text("Friends")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                            
                            // Group Data....
                            
                            ForEach(convos){FriendsChat in
                                
                                // Chat View...
                                
                                ChatView(chatData: FriendsChat, token: $token, user_id: $user_id)
                            }
                    }
                    .padding(.vertical)
                    
                })
                //.clipShape(CustomCorner(corner: .topRight, size: 65))
                // its cutting off inside view may be its a bug....
            }
        }
        .background(Color("bg").ignoresSafeArea(.all, edges: .all))
        .ignoresSafeArea(.all, edges: .top)
        .onAppear(perform: loadMessageData)
    }
}



struct CurvedCorner : Shape {
    
    var corner : UIRectCorner
    var size : CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: size, height: size))
        
        return Path(path.cgPath)
    }
}

struct ChatView : View {
    
    var chatData : FriendsChat
    @Binding var token: String
    @State var tenants = TestData.user
    @Binding var user_id: String
    @State var showChatUI = false
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    
    func loadUser() {
        if (user_id == chatData.user1) {
        guard let user_url = URL(string: "http://18.218.78.71:8080/users/\(chatData.user2)") else {
                print("Your API end point is Invalid")
                return
            }
            var user_request = URLRequest(url: user_url)
            user_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: user_request) { data, response, error in
                if let data = data {
                    if let urlresponse = try? JSONDecoder().decode(userResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.tenants = urlresponse.data
                            print("success")
                            print(self.tenants, "here")
                        }
                        return
                    }
                    
                }
            }.resume()
        } else {
            
            guard let user_url = URL(string: "http://18.218.78.71:8080/users/\(chatData.user1)") else {
                    print("Your API end point is Invalid")
                    return
                }
                var user_request = URLRequest(url: user_url)
                user_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                URLSession.shared.dataTask(with: user_request) { data, response, error in
                    if let data = data {
                        if let urlresponse = try? JSONDecoder().decode(userResponse.self, from: data) {
                            DispatchQueue.main.async {
                                self.tenants = urlresponse.data
                                print("success")
                                print(self.tenants, "here")
                            }
                            return
                        }
                        
                    }
                }.resume()
        
        }
        }
    var body: some View{
        
        ZStack{
            NavigationLink(destination: ChatUI(token: $token, user_id: $user_id, tenant_id: $tenants.id, tenant_prof: $tenants.profilePicture, tenant_name: $tenants.firstName)){
                
                Text("")
            }}
        
        Button(action: {
            self.showChatUI.toggle()
            
            
        }){
        
        HStack(spacing: 10){
            
            
            URLImage(url: tenants.profilePicture)
                .frame(width: 55, height: 55)
                .cornerRadius(27)
                .onAppear(perform: loadUser)
            
            VStack(alignment: .leading, spacing: 8, content: {
                
                Text(tenants.firstName)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .onAppear(perform: loadUser)
                    .foregroundColor(.black)
                
               // name
                
                Text("from your circle at UChicago")
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(.gray)
            })
            
            Spacer(minLength: 0)
            
            Text(dateFormat(string: chatData.modifiedDate), style: .time)
                .font(.system(size: 15))
                .foregroundColor(.black)
        }
        .padding(.horizontal)
        }.sheet(isPresented: $showChatUI) {
            ChatUI(token: $token, user_id: $user_id, tenant_id: $tenants.id, tenant_prof: $tenants.profilePicture, tenant_name: $tenants.firstName)
        }
}

// Model And Sample Data....

//struct Chat : Identifiable {
//
//    var id = UUID().uuidString
//    var name : String
//    var image : String
//    var msg : String
//    var time : String
//}

// were going to do custom grouping of views....

//struct InboxData {
//
//    var groupName : String
//    var groupData : [Chat]
//}

//var FriendsChat : [Chat] = [
//
//
//    Chat(name: "Ryan",image: "p1", msg: "115 W 86th Street", time: "03:45"),
//    Chat(name: "Leon",image: "p2", msg: "635 W 42nd Street", time: "04:55"),
//    Chat(name: "Liana",image: "p3", msg: "101 W Columbus Ave", time: "06:25"),
//    Chat(name: "Lisa",image: "p4", msg: "901 Sutter Ave", time: "07:19"),
//    Chat(name: "Mary",image: "p5", msg: "5717 S Kimbark Ave", time: "08:22"),
//]



//var data = [
//
//    // Group 1
//    InboxData(groupName: "Friends", groupData: FriendsChat),
//
//]
}

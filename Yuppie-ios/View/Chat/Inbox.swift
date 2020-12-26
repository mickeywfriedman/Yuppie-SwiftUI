//
//  Inbox.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 03/10/1399 AP.
//
import SwiftUI

struct Inbox : View {
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var selectedTab = "Chats"
    @Namespace var animation
    
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
                        
                        ForEach(data,id: \.groupName){gData in
                            
                            // Group Name..
                            HStack{
                                
                                Text(gData.groupName)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal)
                            
                            // Group Data....
                            
                            ForEach(gData.groupData){chatData in
                                
                                // Chat View...
                                
                                ChatView(chatData: chatData)
                            }
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
    
    var chatData : Chat
    
    var body: some View{
        
        HStack(spacing: 10){
            
            
            Image(chatData.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
                .cornerRadius(27)
            
            VStack(alignment: .leading, spacing: 8, content: {
                
                Text(chatData.name)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                Text(chatData.msg)
                    .font(.caption)
                    .lineLimit(1)
            })
            
            Spacer(minLength: 0)
            
            Text(chatData.time)
                .font(.system(size: 15))
                .fontWeight(.bold)
        }
        .padding(.horizontal)
    }
}

// Model And Sample Data....

struct Chat : Identifiable {
    
    var id = UUID().uuidString
    var name : String
    var image : String
    var msg : String
    var time : String
}

// were going to do custom grouping of views....

struct InboxData {
    
    var groupName : String
    var groupData : [Chat]
}

var FriendsChat : [Chat] = [

 
    Chat(name: "Ryan",image: "p1", msg: "115 W 86th Street", time: "03:45"),
    Chat(name: "Leon",image: "p2", msg: "635 W 42nd Street", time: "04:55"),
    Chat(name: "Liana",image: "p3", msg: "101 W Columbus Ave", time: "06:25"),
    Chat(name: "Lisa",image: "p4", msg: "901 Sutter Ave", time: "07:19"),
    Chat(name: "Mary",image: "p5", msg: "5717 S Kimbark Ave", time: "08:22"),
]



var data = [

    // Group 1
    InboxData(groupName: "Friends", groupData: FriendsChat),

]

//
//  Messages.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI


struct Home : View {
    @State var showChatUI = false
    @State var showInbox = false
    @State var index = 0
    @State var expand = false
    
    var body : some View{
        
        ZStack{
            
            NavigationLink(destination: ChatUI(), isActive: self.$showChatUI) {
                
                Text("")
            }
            
            
            
            
            VStack{
                
                Color.clear
            }
            
            VStack{
                
                ZStack{
                    
                    Chats(expand: self.$expand).opacity(self.index == 0 ? 1 : 0)
                    
                }
                

                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Chats : View {

    @Binding var expand : Bool
    
    var body : some View{
        
        VStack(spacing: 0){
            
            TopView(expand: self.$expand).zIndex(0)
            
            Centerview(expand: self.$expand).offset(y: -1250)
        }
    }
}


struct TopView : View {
    @State var showChatUI = false
    @State var search = ""
    @Binding var expand : Bool
    @State var showInbox = false
    
    var body : some View{
        
        ZStack{
            
            NavigationLink(destination: ChatUI(), isActive: self.$showChatUI) {
                
                Text("")
            }
            
            NavigationLink(destination: Inbox(), isActive: self.$showInbox) {
                
                Text("")
            }
        
        VStack{
            
            
            if self.expand{
                
                HStack{
                   
                    
                    Button(action: {
                        
                    }) {
                        
                        Image("menu")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.black.opacity(0.4))
                        
                    }
                }.sheet(isPresented: $showChatUI) {
                    ChatUI()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 18){
                        
                        Button(action: {
                            
                          
                                self.showInbox.toggle()
                            
                            
                        }) {
                            
                            Image(systemName: "message")
                            .resizable()
                            .frame(width: 25, height: 25)
                                .foregroundColor(Color.white)
                            .padding(18)
                            
                        }.sheet(isPresented: $showInbox) {
                            Inbox()}.background(Color("blueshadow").opacity(0.5))
                        .clipShape(Circle())
                        
                        
                        ForEach(1...7,id: \.self){i in
                            
                            Button(action: {
                                self.showChatUI.toggle()
                                                        
                            }) {
                                
                                (Image("p\(i)")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 60, height: 60)
                                    .cornerRadius(30)
                                    .overlay(

                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Color.purple, lineWidth: 2)))
                                    .padding(.bottom, 10)
                                    .padding(.top, 10)
                                }
                        }
                    }
                }
                
            }
            
        
            
        }.padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color.clear)
        .clipShape(shape())
        .animation(.default)
        
    }
    }
}

struct Centerview : View {
    
    @Binding var expand : Bool
    
    var body : some View{
        
        List(messageData){i in
            
            if i.id == 0{
                
                cellView(data : i)
                .onAppear {
                        
                    self.expand = true
                }
                .onDisappear {
                    
                    self.expand = false
                }
            }
            else{
                
                cellView(data : i)
            }
            
        }
       
        .background(Color.clear)
     
    }
}



struct cellView : View {
    
    var data : Msg
    
    var body : some View{
        
        HStack(spacing: 12){
            
           
            
          
            Spacer(minLength: 0)
            
           
        }.padding(.vertical)
    }
}

struct shape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        
        return Path(path.cgPath)
    }
}


struct Msg : Identifiable {
    
    var id : Int
    var name : String
    var msg : String
    var date : String
    var img : String
}

var messageData = [
    
    Msg(id: 0, name: "Emily", msg: "Hello!!!", date: "25/03/20",img: "p1"),
    Msg(id: 1, name: "Jonh", msg: "How Are You ???", date: "22/03/20",img: "p2"),
    Msg(id: 2, name: "Catherine", msg: "New Tutorial From Kavsoft", date: "20/03/20",img: "p3"),
    Msg(id: 3, name: "Emma", msg: "Hey Everyone", date: "25/03/20",img: "p4"),
    Msg(id: 4, name: "Lina", msg: "SwiftUI Tutorials", date: "25/03/20",img: "p5"),
    Msg(id: 5, name: "Steve Jobs", msg: "New Apple iPhone", date: "15/03/20",img: "p6"),
    Msg(id: 6, name: "Roy", msg: "Hey Guys!!!", date: "25/03/20",img: "p7"),
    Msg(id: 7, name: "Julia", msg: "Hello!!!", date: "25/03/20",img: "p1"),
    Msg(id: 8, name: "Watson", msg: "How Are You ???", date: "22/03/20",img: "p2"),
    Msg(id: 9, name: "Kavuya", msg: "New Tutorial From Kavsoft", date: "20/03/20",img: "p3"),
    Msg(id: 10, name: "Julie", msg: "Hey Everyone", date: "25/03/20",img: "p4"),
    Msg(id: 11, name: "Lisa", msg: "SwiftUI Tutorials", date: "25/03/20",img: "p5"),
    
]

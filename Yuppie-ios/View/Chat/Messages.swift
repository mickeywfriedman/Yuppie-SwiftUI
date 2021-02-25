//
//  Messages.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI


struct Home : View {
    @Binding var token: String
    @Binding var user : User
    @Binding var user_id: String
    @Binding var building: Building
    @State var tenant_id = ""
    @State var tenant_prof = ""
    @State var showChatUI = false
    @State var showInbox = false
    @State var index = 0
    @State var expand = false
    
    var body : some View{
        ZStack{
            VStack{
                
                Color.clear
            }
            VStack{
                    Chats(token: $token, user: $user, user_id: $user_id, building:building,expand: self.$expand).opacity(self.index == 0 ? 1 : 0)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Chats : View {
    @Binding var token: String
    @Binding var user : User
    @Binding var user_id: String
    var building: Building
    @Binding var expand : Bool
    
    var body : some View{
        
        VStack(spacing: 0){
            
            TopView(token: $token, user: $user, user_id: $user_id, building:building, expand: self.$expand).zIndex(0)
            
            Centerview(expand: self.$expand).offset(y: -1250)
        }.frame(minWidth:(UIScreen.main.bounds.width-40), maxWidth: .infinity)
    }
}


struct TopView : View {
    @Binding var token: String
    @Binding var user : User
    @Binding var user_id: String
    var building: Building
    @State var tenant_id = ""
    @State var tenant_prof = ""
    @State var tenant_name = ""
    @State var showChatUI = false
    @State var search = ""
    @Binding var expand : Bool
    @State var showInbox = false
    
    func getDocumentsDirectory1() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func writeTenant(){
        let text = ""
        
        let filename = getDocumentsDirectory1().appendingPathComponent("index.txt")
        do {
            try text.write(to: filename, atomically: false, encoding: .utf8)
            try (self.tenant_id+self.user_id+("token_id:")+self.token ).write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    var body : some View{
        
        ZStack{
            NavigationLink(destination: ChatUI(token: $token, user_id: $user_id, tenant_id: $tenant_id, tenant_prof: $tenant_prof, tenant_name: $tenant_name)){
                
                Text("")
            }
            
            NavigationLink(destination: Inbox(token: $token, user_id: $user_id, user: $user), isActive: self.$showInbox) {
                
                Text("")
            }
        
        VStack{
            
            
            if true{
                
                HStack{
                   
                    
                    Button(action: {
                        
                    }) {
                        Image("menu")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.black.opacity(0.4))
                    }

                }
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 18){
                        
                        VStack{
                            
                            ZStack{
                        
                        Button(action: {
                                self.showInbox.toggle()
                            
                        }) { Image(systemName: "message")
                            .resizable()
                            .frame(width: 25, height: 25)
                                .foregroundColor(Color.white)
                            .padding(18)
                        }.sheet(isPresented: $showInbox) {
                            Inbox(token: $token, user_id: $user_id, user: $user)}.background(Color("blueshadow").opacity(0.5))
                        .clipShape(Circle())
                            
                            Circle()
                            .trim(from: 0, to: 1)
                                .stroke(AngularGradient(gradient: .init(colors: [.purple,.blue,.purple]), center: .center), style: StrokeStyle(lineWidth: 4, dash: [false ? 7 : 0]))
                            .frame(width: 68, height: 68)
                            .rotationEffect(.init(degrees: true ? 360 : 0))
                                .padding(3)
                                
                            }
                        
                            Label(title: {
                            }) {Text("Inbox")
                                .foregroundColor(Color.black)
                                .lineLimit(1)
                                
                            } .padding(.vertical,4)
                            .padding(.horizontal,10)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .opacity(0.8)
                            
                    }
                        ForEach(building.tenants,id: \.self){tenant in
                            
                            Button(action: {
                                self.showChatUI.toggle()
                                tenant_id = String(tenant.id)
                                tenant_prof = String(tenant.profilePicture)
                                tenant_name = String(tenant.firstName)
                                print(tenant_id)
                                print(self.token)
                                writeTenant()
                            }) {
                                VStack(spacing: 8){
                                ZStack{
                                URLImage(url: tenant.profilePicture)
                                .frame(width: 60, height: 60)
                                    .cornerRadius(30)
                                    .padding(.bottom, 10)
                                    .padding(.top, 10)
                                Circle()
                                .trim(from: 0, to: 1)
                                    .stroke(AngularGradient(gradient: .init(colors: [.purple,.orange,.purple]), center: .center), style: StrokeStyle(lineWidth: 4, dash: [showChatUI ? 3 : 0]))
                                .frame(width: 68, height: 68)
                                .rotationEffect(.init(degrees: showChatUI ? 360 : 0))
                                    .padding(3)
                                }
                                    
                                    Label(title: {
                                    }) {Text(tenant.firstName)
                                        .foregroundColor(Color.black)
                                        .lineLimit(1)
                                    } .padding(.vertical,4)
                                    .padding(.horizontal,10)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                                    .opacity(0.8)
                                    .offset(y: -5)
                                }
                                }.sheet(isPresented: $showChatUI) {
                                    ChatUI(token: $token, user_id: $user_id, tenant_id: $tenant_id, tenant_prof: $tenant_prof, tenant_name: $tenant_name)
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
    
    var data : Msge
    
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


struct Msge : Identifiable {
    
    var id : Int
    var name : String
    var msg : String
    var date : String
    var img : String
}

var messageData = [
    
    Msge(id: 0, name: "Emily", msg: "Hello!!!", date: "25/03/20",img: "p1"),
    Msge(id: 1, name: "Jonh", msg: "How Are You ???", date: "22/03/20",img: "p2"),
    Msge(id: 2, name: "Catherine", msg: "New Tutorial From Kavsoft", date: "20/03/20",img: "p3"),
    Msge(id: 3, name: "Emma", msg: "Hey Everyone", date: "25/03/20",img: "p4"),
    Msge(id: 4, name: "Lina", msg: "SwiftUI Tutorials", date: "25/03/20",img: "p5"),
    Msge(id: 5, name: "Steve Jobs", msg: "New Apple iPhone", date: "15/03/20",img: "p6"),
    Msge(id: 6, name: "Roy", msg: "Hey Guys!!!", date: "25/03/20",img: "p7"),
    Msge(id: 7, name: "Julia", msg: "Hello!!!", date: "25/03/20",img: "p1"),
    Msge(id: 8, name: "Watson", msg: "How Are You ???", date: "22/03/20",img: "p2"),
    Msge(id: 9, name: "Kavuya", msg: "New Tutorial From Kavsoft", date: "20/03/20",img: "p3"),
    Msge(id: 10, name: "Julie", msg: "Hey Everyone", date: "25/03/20",img: "p4"),
    Msge(id: 11, name: "Lisa", msg: "SwiftUI Tutorials", date: "25/03/20",img: "p5"),
    
]

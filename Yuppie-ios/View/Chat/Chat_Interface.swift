//
//  Chat_Interface.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//
import SwiftUI

struct ChatUI : View {
    
    @State var message = ""
    @State var imagePicker = false
    @State var imgData : Data = Data(count: 0)
    
    //StateObject is the owner of the object....
    
    @StateObject var allMessages = Messages()
    
    var body: some View{
        
        VStack{
            
            ZStack{
                
                HStack{
                    
                    Button(action: {}, label: {
                        
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                    }, label: {
                        
                        Image(systemName: "video")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    })
                }
                
                VStack(spacing: 5){
                    
                    Text("Leon")
                        .fontWeight(.bold)
        
                    Text("Gold Member")
                        .font(.caption)
                }
                .foregroundColor(.white)
            }
            .padding(.all)
            
            VStack{
                
                // Displaying Message....
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    ScrollViewReader{reader in
                        
                        VStack(spacing: 20){
                            
                            ForEach(allMessages.messages){msg in
                                
                                // Chat Bubbles...
                                
                                ChatBubble(msg: msg)
                            }
                            // when ever a new data is inserted scroll to bottom...
                            
                            .onChange(of: allMessages.messages) { (value) in
                                
                                // scrolling only user message...
                                
                                if value.last!.myMsg{
                                    
                                    reader.scrollTo(value.last?.id)
                                }
                            }
                        }
                        .padding([.horizontal,.bottom])
                        .padding(.top, 25)
                    }
                })
                
                HStack(spacing: 15){
                    
                    HStack(spacing: 15){
                        
                        TextField("Message", text: self.$message)
                        
                        Button(action: {
                            
                            // toogling image picker...
                            
                            imagePicker.toggle()
                            
                        }, label: {
                            
                            Image(systemName: "paperclip.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                        })
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.black.opacity(0.06))
                    .clipShape(Capsule())
                    
                    // Send Button...
                    
                    // hiding view...
                    
                    if message != ""{
                        
                        Button(action: {
                            
                            // appeding message...
                            
                            // adding animation...
                            
                            withAnimation(.easeIn){
                            
                                allMessages.messages.append(Message(id: Date(), message: message, myMsg: true, profilePic: "p1", photo: nil))
                            }
                            
                            message = ""
                            
                        }, label: {
                            
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color("Color2"))
                                // rotating the image...
                                .rotationEffect(.init(degrees: 45))
                                // adjusting padding shape...
                                .padding(.vertical,12)
                                .padding(.leading,12)
                                .padding(.trailing,17)
                                .background(Color.black.opacity(0.07))
                                .clipShape(Circle())
                        })
                    }
                }
                .padding(.horizontal)
                .animation(.easeOut)
            }
            // since bottom edge is ignored....
            .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            .background(Color.white.clipShape(RoundedShape()))
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(LinearGradient(gradient: .init(colors: [Color("Chat_color"),Color("Color-3"),Color("Chat_color")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.top))
        // Full Screen Image Picker...
        .fullScreenCover(isPresented: self.$imagePicker, onDismiss: {
            
            // when ever image picker closes...
            // verifying if image is selected or cancelled...
            
            if self.imgData.count != 0{
                
                allMessages.writeMessage(id: Date(), msg: "", photo: self.imgData, myMsg: true, profilePic: "Mickey")
            }
            
        }) {
            
            ImagePickerOnboarding(showPicker: self.$imagePicker, imageData: self.$imgData)
        }
    }
}

// Chat Bubbles...

struct ChatBubble : View {

    var msg : Message
    
    var body: some View{
        
        // Automatic scroll To Bottom...
        // First Assigning Id To Each Row...
        
        HStack(alignment: .top,spacing: 10){
            
            if msg.myMsg{
                
                // pushing msg to left...
                
                // minimum space ...
                
                // Modifying for Image...
                
                Spacer(minLength: 25)
                

                if msg.photo == nil{
                    
                    Text(msg.message)
                        .padding(.all)
                        .background(Color.black.opacity(0.06))
                        .clipShape(BubbleArrow(myMsg: msg.myMsg))
                }
                else{
                    
                    Image(uiImage: UIImage(data: msg.photo!)!)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 150, height: 150)
                        .clipShape(BubbleArrow(myMsg: msg.myMsg))
                }
                
                // profile Image...
                
                Image(msg.profilePic)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
            
            else{
                
                // pushing msg to right...
                
                // profile Image...
                
                Image(msg.profilePic)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                if msg.photo == nil{
                    
                    Text(msg.message)
                        .foregroundColor(.white)
                        .padding(.all)
                        .background(Color("Chat_color"))
                        .clipShape(BubbleArrow(myMsg: msg.myMsg))
                }
                else{
                    
                    Image(uiImage: UIImage(data: msg.photo!)!)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 150, height: 150)
                        .clipShape(BubbleArrow(myMsg: msg.myMsg))
                }
                
                
                Spacer(minLength: 25)
            }
        }
        .id(msg.id)
    }
}

// Bubble Arrow...

struct BubbleArrow : Shape {

    var myMsg : Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: myMsg ?  [.topLeft,.bottomLeft,.bottomRight] : [.topRight,.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        return Path(path.cgPath)
    }
}

// Custom Rounded Shape...

struct RoundedShape : Shape {

    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 35, height: 35))
        
        return Path(path.cgPath)
    }
}

// Model Data For Message...

struct Message : Identifiable,Equatable{

    var id : Date
    var message : String
    var myMsg : Bool
    var profilePic : String
    var photo: Data?
    
}

class Messages : ObservableObject{
    
    @Published var messages : [Message] = []
    
    // sample data...
    
    init() {
        
        let strings = ["Hi Leon, we met at UChicago. I saw that you currently live at the Atlier in NYC and had some questions about your experience there.","Hello! I remember. Personally, I love it here and can answer any questions.","Great, so next year I'm going to be doing ibanking at JP so my first concern is that its too far away from my job. What was your commute like?","Commute was fine and short. The atlier is incredibly close to Grand Central so everything in the city is just one or two subway rides away."]
        
        //simple logic for two side messages
        
        for i in 0..<strings.count{
            
            messages.append(Message(id: Date(), message: strings[i], myMsg: i % 2 == 0 ? true : false, profilePic: i % 2 == 0 ? "p1" : "p2"))
        }
    }
    
    func writeMessage(id: Date,msg: String,photo: Data?,myMsg: Bool,profilePic: String){
        
        messages.append(Message(id: id, message: msg, myMsg: myMsg, profilePic: profilePic, photo: photo))
    }
}

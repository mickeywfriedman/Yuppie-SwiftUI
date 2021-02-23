import SwiftUI

struct ChatUI: View {
    @Binding var token: String
    @Binding var user_id: String
    @Binding var tenant_id: String
    @Binding var tenant_prof: String
    @Binding var tenant_name: String
    @StateObject var homeData = ChatModel()
    @State var index: Int = 0
    @AppStorage("current_user") var user = ""
    @State var scrolled = false
    @State var imagePicker2 = false
    @State var imgData : Data = Data(count: 0)
    @StateObject var allMessages = Messages_image()
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    func initiatefirstView() {
    if homeData.msgs.isEmpty{print("f")}
    }
    
    var body: some View {
        
        VStack(spacing: 0){
            
            HStack{
                
                Text("\(tenant_name) Chat")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color("Chat_color").clipShape(RoundedShape()))
            
            
            ScrollViewReader{reader in
                
                ScrollView{
                    
                    
                    VStack(spacing: 15){
                      
                        
                        
                        ForEach(homeData.msgs){msg in
                            
                           ChatRow(token: $token, user_id: $user_id, tenant_id: $tenant_id, tenant_prof: $tenant_prof, chatData: msg)
                            .onAppear{
                              
                                // First Time Scroll
                                if msg.id == self.homeData.msgs.last!.id && !scrolled{
                                    
                                    reader.scrollTo(homeData.msgs.last!.id,anchor: .bottom)
                                    scrolled = true
                                    
                                }
                            }
                        }

                    }
                    .padding(.vertical)
                    
                    
                }
            }
            
            HStack(spacing: 15){
                
                TextField("Enter Message", text: $homeData.txt)
                    .padding(.horizontal)
                    // Fixed Height For Animation...
                    .frame(height: 45)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
                
                Button(action: {
                    
                    // toogling image picker...
                    
                    imagePicker2.toggle()
                    
                }, label: {
                    
                    Image(systemName: "paperclip.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(Color("Chat_color"))
                        .clipShape(Circle())
                })
                
                if homeData.txt != ""{

                    Button(action: homeData.writeMsg, label: {

                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color("Chat_color"))
                            .clipShape(Circle())
                    })
                    
                 
                }
            }
            .animation(.default)
            .padding()
        }
        .ignoresSafeArea(.all, edges: .top)
        .fullScreenCover(isPresented: self.$imagePicker2, onDismiss: {
            
            // when ever image picker closes...
            // verifying if image is selected or cancelled...
            
            if self.imgData.count != 0{
                
                allMessages.writeMessage(id: Date(), msg: "", photo: self.imgData, myMsg: true, profilePic: "p1")
            }
            
        }) {
            
            ImagePicker2(imagePicker2: self.$imagePicker2, imgData: self.$imgData)
        }
        
    }
}

struct RoundedShape : Shape {

    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 35, height: 35))
        
        return Path(path.cgPath)
    }
}

struct ImagePicker1 : UIViewControllerRepresentable {
    
    
    func makeCoordinator() -> Coordinator {
        
        return ImagePicker1.Coordinator(parent1: self)
    }

    @Binding var imagePicker2 : Bool
    @Binding var imgData : Data
    
    func makeUIViewController(context: Context) -> UIImagePickerController{
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePicker1
        
        init(parent1 : ImagePicker1) {
            
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            parent.imagePicker2.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
            parent.imgData = image.jpegData(compressionQuality: 0.5)!
            parent.imagePicker2.toggle()
        }
    }
}

struct ImagePicker2 : UIViewControllerRepresentable {
    
    
    func makeCoordinator() -> Coordinator {
        
        return ImagePicker2.Coordinator(parent1: self)
    }

    @Binding var imagePicker2 : Bool
    @Binding var imgData : Data
    
    func makeUIViewController(context: Context) -> UIImagePickerController{
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePicker2
        
        init(parent1 : ImagePicker2) {
            
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            parent.imagePicker2.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
            parent.imgData = image.jpegData(compressionQuality: 0.5)!
            parent.imagePicker2.toggle()
        }
    }
}

struct Message3 : Identifiable,Equatable{

    var id : Date
    var message : String
    var myMsg : Bool
    var profilePic : String
    var photo: Data?
    
}
class Messages_image : ObservableObject{
    
    @Published var messages : [Message3] = []
    
    // sample data...
    
    init() {
        
        let strings = ["Hii","Hello !!!!","What's Up, What Are You Doing ???","Nothing Just Simply Enjoying Quarintine Holidays..You???","Same :))","Ohhhhh","What About Your Country ???","Very Very Bad...","Ok Be Safe","Bye....","Ok...."]
        
        //simple logic for two side messages
        
        for i in 0..<strings.count{
            
            messages.append(Message3(id: Date(), message: strings[i], myMsg: i % 2 == 0 ? true : false, profilePic: i % 2 == 0 ? "p1" : "p2"))
        }
    }
    
    func writeMessage(id: Date,msg: String,photo: Data?,myMsg: Bool,profilePic: String){
        
        messages.append(Message3(id: id, message: msg, myMsg: myMsg, profilePic: profilePic, photo: photo))
    }
}


//
//  Verification.swift
//  Complex Curve
//
//  Created by Mickey Friedman on 02/10/1399 AP.
//




import SwiftUI

struct Verification: View {
    
    @State var code = ""
    @State var number = ""
    @State var showBirthday = false
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    @StateObject var serverData = UniversityModel()
    
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination: Birthday(), isActive: self.$showBirthday) {
                
                Text("")
            }
            
            
            VStack(spacing: 35){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                        .clipShape(CustomShapeOnboarding())
                    
                    
                    VStack{
                        
                        Button(action: {serverData.isConnected.toggle()}, label: {
                            
                            VStack(spacing: 45){
                                
                                Image(systemName: "phone")
                                    .font(.system(size: 70))
                                    .foregroundColor(serverData.isConnected ? Color.red.opacity(0.6) : Color("power"))
                                    .frame(height: UIScreen.main.bounds.height / 9)

                            }
                            .padding(50)
                            .background(
                            
                                LinearGradient(gradient: .init(colors: [Color("pgradient1"),Color("pgradient2")]), startPoint: .top, endPoint: .bottom)
                            )
                            .clipShape(Circle())
                            .padding(15)
                            .background(Color("power1").opacity(0.7))
                            .clipShape(Circle())
                            .padding(15)
                            .background(Color("gradient2").opacity(0.7))
                            .clipShape(Circle())
                        })
                        .offset(y: -65)
                        .padding(.bottom,-65)
                        
                        Text("Enter the 6 digit code just texted to you.")
                            .foregroundColor(Color.white)
                        HStack(spacing: 15){
                            Spacer()

                            TextField("Code", text: self.$code)
                                .keyboardType(.numberPad)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                                
                            Spacer()
                        }
                        .offset(y: 30)
                        Button(action: {
                            
                            self.showBirthday.toggle()
                            
                        }) {
                            
                            Text("Verify")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 45)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                        }
                        // disabling view when both textfields are empty...
                        .opacity((self.code == "") ? 0.65 : 1)
                        .disabled((self.code == "") ? true : false).offset(y: 70)
                        
                        Spacer()
                        
                        
                    }
                    
                })
                .padding(.top,60)
                

            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
        
            ZStack{
                
                LinearGradient(gradient: .init(colors: gradient), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.1)
                    .ignoresSafeArea(.all, edges: .top)
            }
        )
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

//
//  PhoneAuth.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 04/10/1399 AP.
//

import SwiftUI

struct PhoneAuth: View {
    
    @State var countryCode = ""
    @State var number = ""
    @State var showVerification = false
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    @StateObject var universityData = UniversityModel()
    
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination: Verification(), isActive: self.$showVerification) {
                
                Text("")
            }
            
            
            VStack(spacing: 35){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                        .clipShape(CustomShapeOnboarding())
                    
                    
                    VStack{
                        
                        Button(action: {universityData.isConnected.toggle()}, label: {
                            
                            VStack(spacing: 45){
                                
                                Image(systemName: "phone")
                                    .font(.system(size: 70))
                                    .foregroundColor(universityData.isConnected ? Color.red.opacity(0.6) : Color("power"))
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
                        
                        Text("Enter your Phone Number for Verification")
                            .foregroundColor(Color.white)
                        
                       
                        HStack(spacing: 15){
                            Spacer()
                            TextField("1", text: self.$countryCode)
                                .keyboardType(.numberPad)
                                // fixed Width...
                                .frame(width: 50)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                            
                            TextField("Mobile Number", text: self.$number)
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
                            
                            self.showVerification.toggle()
                            
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
                        .opacity((self.countryCode == "" || self.number == "") ? 0.65 : 1)
                        .disabled((self.countryCode == "" || self.number == "") ? true : false).offset(y: 70)
                        
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

struct PhoneAuth_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuth()
    }
}
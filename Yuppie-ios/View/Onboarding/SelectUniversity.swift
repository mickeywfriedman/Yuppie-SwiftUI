//
//  University.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 05/10/1399 AP.
//

import SwiftUI

struct SelectUniversity: View {
    
    @State var showPhoneAuth = false
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    @StateObject var universityData = UniversityModel()
    
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination: PhoneAuth(), isActive: self.$showPhoneAuth) {
                
                Text("")
            }
            
            VStack{
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                        .clipShape(CustomShapeOnboarding())
                    
                    
                    VStack{
                        
                        Button(action: {universityData.isConnected.toggle()}, label: {
                            
                            VStack(spacing: 15){
                                
                                Image(systemName: "studentdesk")
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
                        
                        Text("Select your University")
                            .foregroundColor(Color.white)
                        Button(action: {
                            withAnimation{universityData.showSheet.toggle()}
                        }, label: {
                            
                            // CardViewOnboarding....
                            
                            CardViewOnboarding(University: universityData.currentUniversity,subTitle: "")
                                .background(BlurView())
                                .clipShape(Capsule())
                                .padding()
                        }
                        
                        
                        
                        
                        )
                        
                        Button(action: {
                            
                            self.showPhoneAuth.toggle()
                            
                        }) {
                            
                            Text("Next")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 45)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                        }
                        // disabling view when both textfields are empty...
                        
                        
                        Spacer()
                        
                        
                        Spacer()
                    }
                    
                })
                .padding(.top,60)

            }
            
            BottomSheet(universityData: universityData)
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


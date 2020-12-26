//
//  ProfilePicture.swift
//  Complex Curve
//
//  Created by Mickey Friedman on 02/10/1399 AP.
//


import SwiftUI

struct ProfilePicture: View {
    
    @State var countryCode = ""
    @State var number = ""
    @State var MoveIn = Date()
    @State var showVerification = false
    @State var showsDatePicker = false
    @State var images : [Data] = [Data(),Data(),Data(),Data()]
    @State var imagePicker = true
    @State var index = 0
    @State var showProfile = false
    
    let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateStyle = .medium
            return df
        }()
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    @StateObject var serverData = UniversityModel()
    
    var body: some View {
        
        ZStack{
            
            VStack(spacing: 35){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    LinearGradient(gradient: .init(colors: gradient1), startPoint: .top, endPoint: .bottom)
                        .clipShape(CustomShapeOnboarding())
                    
                    
                    VStack{
                        
                        Button(action: {serverData.isConnected.toggle()}, label: {
                            
                            VStack(spacing: 45){
                                
                                Image(systemName: "calendar")
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
                        
                       
                        HStack(spacing: 15){
                            
                            Button(action: {
                                
                                self.index = 0
                                self.imagePicker.toggle()
                                
                            }) {
                                
                                ZStack{
                                    
                                    if self.images[0].count == 0{
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("Color1"))
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 24, weight: .bold))
                                    }
                                    else{
                                        
                                        Image(uiImage: UIImage(data: self.images[0])!)
                                        .resizable()
                                        .renderingMode(.original)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 100)
                                        .cornerRadius(10)
                                    }
                                }
                                // Fixed Height...
                                .frame(height: 100)
                            }.sheet(isPresented: self.$imagePicker) {
                                
                                ImagePickerOnboarding(showPicker: self.$imagePicker, imageData: self.$images[self.index])
                            }
                            
                            
                        }
                        .offset(x: -25, y: 30)
                        Button(action: {
                            
                            self.showVerification.toggle()
                            
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
                        .offset(y: 70)
                        
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
    
    func verifyImages()->Bool{
        
        var status = true
        
        for i in self.images{
            
            if i.count == 0{
                
                status = false
            }
        }
        
        return status
    }
}

struct ProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

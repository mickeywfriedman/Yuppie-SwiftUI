//
//  Settings.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 05/12/1399 AP.
//

import SwiftUI

struct Settingsw: View {

    @State var offset : CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        
        ZStack{
            
            
            VStack{
                
                Spacer()
                
                CustomActionSheet()
                .offset(y: self.offset)
                .gesture(DragGesture()
                
                    .onChanged({ (value) in
                        
                        if value.translation.height > 0{
                            
                            self.offset = value.location.y
                            
                        }
                    })
                    .onEnded({ (value) in
                        
                        if self.offset > 100{
                            
                            self.offset = UIScreen.main.bounds.height
                        }
                        else{
                            
                            self.offset = 0
                        }
                    })
                )
                
            }.background((self.offset <= 100 ? Color(UIColor.label).opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                
                self.offset = 0
                
            })
            
            .edgesIgnoringSafeArea(.bottom)
            
        }.animation(.default)
    }
}



struct CustomActionSheet : View {
    
    @State var show1 = false
    @State var show2 = false
    @State var show3 = false
    @State var show4 = false
    @State var count = 0
    
    var body : some View{
        
        VStack(spacing: 15){
            
            Toggle(isOn: self.$show1) {
                
                Text("Notifications")
            }
            
            Toggle(isOn: self.$show2) {
                
                Text("Likes")
            }
            
            Toggle(isOn: self.$show3) {
                
                Text("Comments")
            }
            
            Toggle(isOn: self.$show4) {
                
                Text("Subscribers Count")
            }
            
            Stepper(onIncrement: {
                
                self.count += 1
                
            }, onDecrement: {
                
                if self.count != 0{
                    
                    self.count -= 1
                }
                
            }) {
                
                Text("Notifications Limit = \(self.count)")
            }
            
        }.padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
        .padding(.horizontal)
        .padding(.top,20)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(25)
        
    }
}

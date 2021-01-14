//
//  BottomSheet.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 04/10/1399 AP.
//
import SwiftUI

struct BottomSheet_buildings: View {
    
    @ObservedObject var buildingsData : AddressModel
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var offset : CGFloat = 0
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
            VStack(spacing: 12){
                
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 60, height: 4)
                
                Text("Select School")
                    .foregroundColor(.gray)
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    
                    VStack(spacing: 0){
                        
                        ForEach(buildingsData.universities){university in
                            
                            CardViewOnboarding(University: university,subTitle: buildingsData.currentUniversity.name == university.name ? "CURRENTLY SELECTED" : "")
                                .contentShape(Rectangle())
                                .onTapGesture(perform: {
                                    
                                    buildingsData.currentUniversity = university
                                    withAnimation{
                                        
                                        buildingsData.showSheet.toggle()
                                    }
                                })
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .padding(.bottom,edges?.bottom)
                })
                .frame(height: UIScreen.main.bounds.height / 3)
                .contentShape(Rectangle())
            }
            .padding(.top)
            .background(BlurView().clipShape(CustomCorner(corners: [.topLeft,.topRight])))
            .offset(y: offset)
            // bottom sheet remove swipe gesture....
            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnded(value:)))
            .offset(y: buildingsData.showSheet ? 0 : UIScreen.main.bounds.height)
        }
        .ignoresSafeArea()
        .background(
            Color.black.opacity(buildingsData.showSheet ? 0.3 : 0).ignoresSafeArea()
                .onTapGesture(perform: {
                    withAnimation{buildingsData.showSheet.toggle()}
                })
        )
    }
    
    func onChanged(value: DragGesture.Value){
        
        if value.translation.height > 0{
            
            offset = value.translation.height
        }
    }
    
    func onEnded(value: DragGesture.Value){
        
        if value.translation.height > 0{
            
            withAnimation(Animation.easeIn(duration: 0.2)){
            
                // checking.....
                
                let height = UIScreen.main.bounds.height / 3
                
                if value.translation.height > height / 1.5{
                    
                    buildingsData.showSheet.toggle()
                }
                offset = 0
            }
        }
    }
}


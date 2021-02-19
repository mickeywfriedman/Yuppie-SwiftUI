//
//  BuildingGallery.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/11/1399 AP.
//
import SwiftUI

struct BuildingGallery: View {
    var buildings: [Building]
    var user: User
    func getImages() -> [String] {
        for building in buildings {
            if building.id == user.building{
                return building.images
            }
        }
        return []
    }
    var columns = Array(repeating: GridItem(.flexible(),spacing: 20), count: 2)
    var body: some View {
        ScrollView{
            
            VStack(spacing: 18){
                LazyVGrid(columns: columns,spacing: 20){
                    
                    ForEach(getImages(), id: \.self) {image in
                        ImageView(url:image)
                            .frame(width:UIScreen.main.bounds.width-100, height: 200)
                                .cornerRadius(20)
                            .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 180)
                            .cornerRadius(15)
                        }
                    }
                }
                .padding(.top,10)
            }
            .padding()
            
            // padding miniplayer size as bottom...
            //.padding(.bottom,80)
        }
        }

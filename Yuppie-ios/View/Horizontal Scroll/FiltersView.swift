//
//  FiltersView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI

struct FiltersView: View {
    @Binding var showFilters: Bool
    @Binding var Bedroom : Int
    @Binding var Bathroom : Int
    @Binding var MaxPrice : Double
    @Binding var MinDate : Date
    @Binding var MaxDate : Date
    var Bedrooms = ["Studio", "1", "2", "3+"]
    var Bathrooms = ["1", "2", "3"]
    @State var animals = false
    @State var gym = false
    @State var rooftop = false
    @State var balcony = false
    @State var airConditioning = false
    @State var doorman = false
    func priceFormat(price : Double) -> String {
        var result = ""
        if (price == 10000) {
            result = "10000+"
        }
        else {
            result = String(format: "%.0f", price)
        }
        return result
    }
    var body: some View {
        VStack{
            Text("Edit Preferences").fontWeight(.heavy).font(.largeTitle)
                .padding(.vertical)
        VStack{
            HStack{
                Text("Min Bedrooms").fontWeight(.heavy)
                Spacer()
            }
            Picker(selection: $Bedroom, label:
                    Text(Bedrooms[Bedroom]).foregroundColor(.purple)
                        .background(Color.white)
            ) {
                ForEach(0 ..< Bedrooms.count) {
                    Text(self.Bedrooms[$0])
                }
                .padding(1.0)
                }.pickerStyle(SegmentedPickerStyle())
        
            HStack{
                Text("Min Bathrooms").fontWeight(.heavy)
                Spacer()
            }
            Picker(selection: $Bathroom, label:
                    Text(Bathrooms[Bathroom]).foregroundColor(.purple)
                        .background(Color.white)
            ) {
                ForEach(0 ..< Bathrooms.count) {
                    Text(self.Bathrooms[$0])
                }
                .padding(1.0)
            }.pickerStyle(SegmentedPickerStyle())
            
            HStack{
                Text("The most I can pay is $\(priceFormat(price:MaxPrice))").fontWeight(.heavy)
                Spacer()
            }
            Slider(value: $MaxPrice, in: 1000...10000)
            VStack{
                HStack{
                    Text("Anticipated Move In Date").fontWeight(.heavy)
                    Spacer()
                    
                }
                DatePicker("Earliest Move In", selection: $MinDate, displayedComponents: .date)
                .foregroundColor(.black)
                .background(Color.white)
                .datePickerStyle(DefaultDatePickerStyle())
            DatePicker("Latest Move In", selection: $MaxDate, displayedComponents: .date)
                .foregroundColor(.black)
                .background(Color.white)
                .datePickerStyle(DefaultDatePickerStyle())
            HStack{
                Text("I can't live without").fontWeight(.heavy)
                Spacer()
            }
            }
            HStack{
                if self.animals { Button(action:{
                    self.animals = !self.animals
                }) {
                    Text("Animals")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                        self.animals = !self.animals
                    }) {
                        Text("Animals")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                }
                if self.gym { Button(action:{
                    self.gym = !self.gym
                }) {
                    Text("Gym")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{self.gym = !self.gym}) {
                        Text("Gym")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                    
                }
            }
            
            HStack{
                if self.rooftop { Button(action:{
                    self.rooftop = !self.rooftop
                }) {
                    Text("Rooftop")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                        self.rooftop = !self.rooftop
                    }) {
                        Text("Rooftop")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                }
                if self.balcony { Button(action:{
                    self.balcony = !self.balcony
                }) {
                    Text("Balcony")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{self.balcony = !self.balcony}) {
                        Text("Balcony")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                    
                }
            }
            HStack{
                if self.airConditioning { Button(action:{
                    self.airConditioning = !self.airConditioning
                }) {
                    Text("Air Conditioning")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                        self.airConditioning = !self.airConditioning
                    }) {
                        Text("Air Conditioning")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                }
                if self.doorman { Button(action:{
                    self.doorman = !self.doorman
                }) {
                    Text("Doorman")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{self.doorman = !self.doorman}) {
                        Text("Doorman")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                    
                }
            }
        }
            
            Spacer()
        }.padding()
    }
}

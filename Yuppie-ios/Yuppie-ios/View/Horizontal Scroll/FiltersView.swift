//
//  FiltersView.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI

struct FiltersView: View {
    @Binding var showFilters: Bool
    var Bedrooms = ["Studio", "1", "2", "3+"]
    @Binding var token: String
    @Binding var user : User
    @Binding var user_id: String
    @State var minDate: Date
    @State var maxDate: Date
    var Bathrooms = ["1", "2", "3"]
    @State var animals = false
    @State var gym = false
    @State var rooftop = false
    @State var balcony = false
    @State var airConditioning = false
    @State var doorman = false
    var isExceeded = false
    
    var chips = ["doorman","pool","gym", "spa"]
    func dateFormat(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    func updateFilters() -> Void {
        self.user.preferences.earliestMoveInDate = "\(dateFormat(date: minDate))"
        self.user.preferences.latestMoveInDate = "\(dateFormat(date: maxDate))"
        guard let filter_url = URL(string: "http://18.218.78.71:8080/users/\(user_id)") else {
            print("Your API end point is Invalid")
            return
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(update(preferences: user.preferences)) else {
            print("Failed to encode order")
            return
        }
        var filter_request = URLRequest(url: filter_url)
        filter_request.httpMethod = "PATCH"
        filter_request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        filter_request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        filter_request.httpBody = data
        URLSession.shared.dataTask(with: filter_request) { data, response, error in
            return
            
        }.resume()
    }
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
        ScrollView{
        VStack{
            Text("Edit Preferences").fontWeight(.heavy).font(.largeTitle)
                .padding(.vertical)
        VStack{
            HStack{
                Text("Min Bedrooms").fontWeight(.heavy)
                Spacer()
            }
            Picker(selection: $user.preferences.bedrooms, label:
                    Text(Bedrooms[user.preferences.bedrooms]).foregroundColor(.purple)
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
            Picker(selection: $user.preferences.bathrooms, label:
                    Text(Bathrooms[user.preferences.bathrooms]).foregroundColor(.purple)
                        .background(Color.white)
            ) {
                ForEach(0 ..< Bathrooms.count) {
                    Text(self.Bathrooms[$0])
                }
                .padding(1.0)
            }.pickerStyle(SegmentedPickerStyle())
            
            HStack{
                Text("The most I can pay is $\(priceFormat(price:user.preferences.price))").fontWeight(.heavy)
                Spacer()
            }
            Slider(value: $user.preferences.price, in: 1000...10000)
            VStack{
                HStack{
                    Text("Anticipated Move In Date").fontWeight(.heavy)
                    Spacer()
                    
                }
                DatePicker("Earliest Move In", selection: $minDate, displayedComponents: .date)
                .foregroundColor(.black)
                .background(Color.white)
                .datePickerStyle(DefaultDatePickerStyle())
            DatePicker("Latest Move In", selection: $maxDate, displayedComponents: .date)
                .foregroundColor(.black)
                .background(Color.white)
                .datePickerStyle(DefaultDatePickerStyle())
            HStack{
                Text("I can't live without").fontWeight(.heavy)
                Spacer()
            }
            }
//            HStack{
//                if self.animals { Button(action:{
//                    self.animals = !self.animals
//                }) {
//                    Text("Animals")
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
//                        .background(Color.purple)
//                        .cornerRadius(30.0)
//                }
//                }
//                else {
//                    Button(action:{
//                        self.animals = !self.animals
//                    }) {
//                        Text("Animals")
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
//                            .background(Color.gray)
//                            .cornerRadius(30.0)
//                    }
//                }
//                if self.gym { Button(action:{
//                    self.gym = !self.gym
//                }) {
//                    Text("Gym")
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
//                        .background(Color.purple)
//                        .cornerRadius(30.0)
//                }
//                }
//                else {
//                    Button(action:{self.gym = !self.gym}) {
//                        Text("Gym")
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
//                            .background(Color.gray)
//                            .cornerRadius(30.0)
//                    }
//
//                }
//            }
            
           
//            LazyVStack(alignment: .leading,spacing: 10){
//
//
//                if self.rooftop { Button(action:{
//                    self.rooftop = !self.rooftop
//                }) {
//                    Text("Rooftop")
//                        .fontWeight(.semibold)
//                        .padding(.vertical,10)
//                        .padding(.horizontal)
//                        .background(Capsule().stroke(Color.black,lineWidth: 1))
//                        .lineLimit(1)
//                }
//                }
//                else {
//                    Button(action:{
//                        self.rooftop = !self.rooftop
//                    }) {
//                        Text("Rooftop")
//                            .fontWeight(.semibold)
//                            .padding(.vertical,10)
//                            .padding(.horizontal)
//                            .background(Capsule().stroke(Color.black,lineWidth: 1))
//                            .lineLimit(1)
//                    }
//                }
//                if self.balcony { Button(action:{
//                    self.balcony = !self.balcony
//                }) {
//                    Text("Balcony")
//                        .fontWeight(.semibold)
//                        .padding(.vertical,10)
//                        .padding(.horizontal)
//                        .background(Capsule().stroke(Color.black,lineWidth: 1))
//                        .lineLimit(1)
//                }
//                }
//                else {
//                    Button(action:{self.balcony = !self.balcony}) {
//                        Text("Balcony")
//                            .fontWeight(.semibold)
//                            .padding(.vertical,10)
//                            .padding(.horizontal)
//                            .background(Capsule().stroke(Color.black,lineWidth: 1))
//                            .lineLimit(1)
//                    }
//
//                }
//                if self.airConditioning { Button(action:{
//                    self.airConditioning = !self.airConditioning
//                }) {
//                    Text("Air Conditioning")
//                        .fontWeight(.semibold)
//                        .padding(.vertical,10)
//                        .padding(.horizontal)
//                        .background(Capsule().stroke(Color.black,lineWidth: 1))
//                        .lineLimit(1)
//                }
//                }
//                else {
//                    Button(action:{
//                        self.airConditioning = !self.airConditioning
//                    }) {
//                        Text("Air Conditioning")
//                            .fontWeight(.semibold)
//                        .padding(.vertical,10)
//                        .padding(.horizontal)
//                        .background(Capsule().stroke(Color.black,lineWidth: 1))
//                        .lineLimit(1)
//                    }
//                }
//                if self.doorman { Button(action:{
//                    self.doorman = !self.doorman
//                }) {
//                    Text("Doorman")
//                        .fontWeight(.semibold)
//                        .padding(.vertical,10)
//                        .padding(.horizontal)
//                        .background(Capsule().stroke(Color.black,lineWidth: 1))
//                        .lineLimit(1)
//                }
//                }
//                else {
//                    Button(action:{self.doorman = !self.doorman}) {
//                        Text("Doorman")
//                            .fontWeight(.semibold)
//                            .padding(.vertical,10)
//                            .padding(.horizontal)
//                            .background(Capsule().stroke(Color.black,lineWidth: 1))
//                            .lineLimit(1)
//                    }
//
//                }
//            }
            ScrollView{
                // Chips View...
                LazyVStack(alignment: .leading,spacing: 10){
                    
                    // Since Were Using Indices So WE Need To Specify Id....
                        
                        HStack{
                            
                            ForEach(chips.indices,id: \.self){index in
                             
                                Text(chips[index])
                                    .fontWeight(.semibold)
                                    .padding(.vertical,10)
                                    .padding(.horizontal)
                                    .background(Capsule().stroke(Color.black,lineWidth: 1))
                                    .lineLimit(1)
                                // Main Logic......
                                    .overlay(
                                    
                                        GeometryReader{reader -> Color in
                                            
                                            // By Using MaxX Parameter We Can Use Logic And Determine if its exceeds or not....
                                            
                                            let maxX = reader.frame(in: .global).maxX
                                            
                                            // Both Paddings  = 30+ 30 = 60
                                            // Plus 10 For Extra....
                                            
                                            // Doing Action Only If The Item Exceeds...
                                            
                                            if maxX > UIScreen.main.bounds.width - 70 {
                                                
                                                // It is updating to each user interaction....
                                                
                                              
                                            }
                                            
                                            return Color.clear
                                        },
                                        alignment: .trailing
                                    )
                                    .clipShape(Capsule())
                                
                            }
        
                    }
                }
                .padding()
            }
            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 3)
            // Border...
            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.0),lineWidth: 1.5))
            // TextEditor....
            
            

        .padding()
//
        }
            
            
            
            Spacer()
        }.padding()
        .onDisappear(perform: updateFilters)
        
    }
    
}

}

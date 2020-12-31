//
//  PropertyManagerForm.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 29/09/1399 AP.
//

import SwiftUI

struct PropertyManagerForm : View {
    @Binding var showForm: Bool
    @State var MoveIn = Date()
    @State var Apartment = 0
    @State var Message = ""
    @State var amenityHours = false
    @State var petPolicy = false
    @State var additionalCharges = false
    @State var localActivites = false
    @State var Parking = false
    @State var covidPolicies = false
    @State var askString = ""
    func sendEmail (Message: String, Apartment: String, userName: String, amenityHours: Bool, petPolicy: Bool, additionalCharges: Bool, localActivites: Bool, Parking: Bool, covidPolicies: Bool){
        self.amenityHours = false
        self.petPolicy = false
        self.additionalCharges = false
        self.localActivites = false
        self.Parking = false
        self.covidPolicies = false
        self.Apartment = 0
    }
    var userName = "Mickey"
    var Apartments = ["5E", "7C", "11B", "8D"]
    func dateFormat(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    var body : some View{
        let message = "Hello my name is \(userName) and I am interested in Unit \(Apartments[Apartment]) and would like to move in around \(dateFormat(date: MoveIn)). Can you tell me more about: \n\(self.amenityHours ? "-Amenity Hours\n": "")\(self.petPolicy ? "-Pet Policy\n": "")\(self.additionalCharges ? "-Additional Charges\n": "")\(self.localActivites ? "-Local Activities\n": "")\(self.covidPolicies ? "-Covid Policies\n": "")\(self.Parking ? "-Parking\n": "")"
        VStack(alignment: .center){
            Text("Contact Property").fontWeight(.heavy).font(.largeTitle)
                .padding(.vertical).foregroundColor(.black)
            HStack{
                Text("Ask About:").foregroundColor(.black)
            Spacer()
            }
            HStack{
                if self.amenityHours { Button(action:{
                    self.amenityHours = !self.amenityHours
                    self.Message = message
                }) {
                    Text("Amenity Hours")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                        self.amenityHours = !self.amenityHours
                        self.Message = message
                    }) {
                        Text("Amenity Hours")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                }
                if self.petPolicy { Button(action:{
                    self.petPolicy = !self.petPolicy
                    self.Message = message
                }) {
                    Text("Pet Policy")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                            self.petPolicy = !self.petPolicy
                            self.Message = message
                    }) {
                        Text("Pet Policy")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                    
                }
            }
            HStack{
                if self.additionalCharges { Button(action:{
                    self.additionalCharges = !self.additionalCharges
                    self.Message = message
                }) {
                    Text("Additional Charges")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                            self.additionalCharges = !self.additionalCharges
                            self.Message = message
                    }) {
                        Text("Additional Charges")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                }
                if self.localActivites { Button(action:{
                    self.localActivites = !self.localActivites
                    self.Message = message
                }) {
                    Text("Local Activities")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{self.localActivites = !self.localActivites}) {
                        Text("Local Activities")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                    
                }
            }
            HStack{
                if self.Parking { Button(action:{
                    self.Parking = !self.Parking
                    self.Message = message
                }) {
                    Text("Parking")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{
                        self.Parking = !self.Parking
                        self.Message = message
                    }) {
                        Text("Parking")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                }
                if self.covidPolicies { Button(action:{
                    self.covidPolicies = !self.covidPolicies
                    self.Message = message
                }) {
                    Text("Covid Policy")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                        .background(Color.purple)
                        .cornerRadius(30.0)
                }
                }
                else {
                    Button(action:{self.covidPolicies = !self.covidPolicies}) {
                        Text("Covid Policy")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width/2) - 10, height: 50)
                            .background(Color.gray)
                            .cornerRadius(30.0)
                    }
                    
                }
            }
            
            HStack{
                Text("Select Apartment").foregroundColor(.black)
                Spacer()
                Picker(selection: $Apartment, label:
                        Text(Apartments[Apartment]).foregroundColor(.blue)
                        .background(Color.white)
            ) {
                ForEach(0 ..< Apartments.count) {
                    Text(self.Apartments[$0])
                }
                .padding(1.0)
                }.pickerStyle(MenuPickerStyle())
                .onReceive([self.Apartment].publisher.first()) { value in
                    self.Message = message
                 }

            }
            
            DatePicker("Move In Date", selection: $MoveIn, displayedComponents: .date)
                .foregroundColor(.black)
                .background(Color.white)
                .datePickerStyle(CompactDatePickerStyle())
                .onReceive([self.MoveIn].publisher.first()) { value in
                    self.Message = message
                 }
            TextEditor(text:$Message)
                .border(Color.black, width: 2)
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight:300, maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
        
            Button(action: {
                self.showForm.toggle()
                sendEmail(Message: Message, Apartment: Apartments[Apartment], userName: userName, amenityHours: amenityHours, petPolicy: petPolicy, additionalCharges: additionalCharges, localActivites: localActivites, Parking: Parking, covidPolicies: covidPolicies)
            }) {
                Text("Send Message").font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
        }.padding()
    }
}



struct PropertyManagerForm_Previews: PreviewProvider {

    static var previews: some View {
        PropertyManagerForm(showForm:.constant(true))
    }
}

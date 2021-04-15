//
//  SubmitPropertyManager.swift
//  Nested
//
//  Created by Ryan Cao on 4/15/21.
//

import SwiftUI

struct SubmitPropertyManager: View {
    @State var submitted = false
    @State var companyName = ""
    @State var address = ""
    @State var contactName = ""
    @State var contactPhone = ""
    @State var contactEmail = ""
    
    var body: some View {
        if submitted{
            Text("Thank you for submitting your property manager.").padding()
        } else {
        VStack(alignment: .center){
            Text("Submit Property").fontWeight(.heavy).font(.largeTitle)
                .padding(.bottom)
            VStack{
                TextField("Address", text: self.$address)
                Divider()
            }
            VStack{
                TextField("Property Manager Company", text: self.$companyName)
                Divider()
            }
            VStack{
                TextField("Property Manager Name", text: self.$contactName)
                Divider()
            }
            VStack{
                TextField("Property Manager Phone", text: self.$contactPhone)
                Divider()
            }
            VStack{
                TextField("Property Manager Email", text: self.$contactEmail)
                Divider()
            }
            Text("Submit")
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
                .onTapGesture {
                    self.submitted = true
                }
            Spacer()
        }.padding()
        }
    }
}


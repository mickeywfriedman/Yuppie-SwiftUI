//
//  Feedback.swift
//  Nested
//
//  Created by Ryan Cao on 4/15/21.
//

import SwiftUI
import Combine

struct Feedback: View {
    @State var message = ""
    @State var submitted = false
    var body: some View {
        if submitted {
            Text("Thank you for your feedback.")
        } else {
        Text("Please tell us how we can improve")
        TextEditor(text:$message)
            .border(Color.black, width: 2)
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight:300, maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding()
        Button(action: {
            self.submitted = true
        }) {
            Text("Submit Feedback").font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                .background(Color.blue)
                .cornerRadius(15.0)
        }
        }
            }
}


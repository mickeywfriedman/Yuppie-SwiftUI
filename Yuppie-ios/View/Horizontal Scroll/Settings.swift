
//
//  Settings.swift
//  Nested
//
//  Created by Ryan Cao on 3/22/21.
//

import SwiftUI

struct Settings: View {
    @Binding var user_id : String
    @Binding var showSettings: Bool
    func logout() -> Void {
        self.user_id = ""
        UserDefaultsService().removeUserInfo()
    }
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView{
            VStack{
            NavigationLink(destination: Terms()) {
                Text("Terms and Conditions").foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            NavigationLink(destination: Privacy()) {
                Text("Privacy Policy").foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            NavigationLink(destination: Text("Contact Leon@NestedApp.com with any questions!")) {
                Text("Contact Us").foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            Text("Logout").onTapGesture {
                showSettings = false
                presentationMode.wrappedValue.dismiss()
                let seconds = 0.1
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    logout()
                }
            }
            }
        }

    }
}


struct Terms: View {
    var body: some View {
        ScrollView{
            VStack{
                
                Text("Terms and Conditions")
                    .font(.custom("Futura", size: 28))
                    .fontWeight(.heavy)
                Spacer()
                
              
                Text("""
Accuracy warning
Nested’s Services and their components are offered for informational purposes. Clients and Tenants bring content onto our mobile and web applications and Nested shall not be responsible or liable for the accuracy, usefulness or availability of any information transmitted or made available via the site and shall not be responsible or liable for any error or omissions in that information.

Advertiser Relationship
Nested is fundamentally an advertisement business for properties and their owners and/or managers. Nested’s Clients pay Nested to list their properties and learn about the engagement that their properties receive.

Termination Clause
Nested may terminate your access to any of its mobile or web applications, without cause or notice, which may result in the forfeiture and destruction of all information associated with your account. All provisions of this Agreement that, by their nature, should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity, and limitations of liability.

Notification of Changes
Nested reserves the right to change these conditions from time to time as it sees fit and your continued use of the site will signify your acceptance of any adjustment to these terms. If there are any changes to our privacy policy, we will announce that these changes have been made on our home page and on other key pages and applications. As well, any changes to our privacy policy will be posted on our site 30 days prior to these changes taking place. You are therefore advised to re-read this statement on a regular basis.

""")
                    .font(.custom("Futura", size: 18))
                
            }.padding(.horizontal, 25)
        }
    }
}

struct Privacy: View {
    var body: some View {
        ScrollView{
            VStack{
                
                Text("Privacy Policy")
                    .font(.custom("Futura", size: 28))
                    .fontWeight(.heavy)
                Spacer()
                
              
                Text("""
Privacy Policy
Yuppie’s Privacy Policy can be found here.

Accuracy warning
Yuppie’s Services and their components are offered for informational purposes; Clients and Tenants bring content onto our mobile and web applications and Yuppie shall not be responsible or liable for the accuracy, usefulness or availability of any information transmitted or made available via the site and shall not be responsible or liable for any error or omissions in that information.

Advertiser Relationship
Yuppie is fundamentally an advertisement business for properties and their owners and/or managers. Yuppie’s Clients pay Yuppie to list their properties and learn about the engagement that their properties receive.

Accepted Payment Methods
Payment processing---

Termination Clause
Yuppie may terminate your access to any of its mobile or web applications, without cause or notice, which may result in the forfeiture and destruction of all information associated with your account. All provisions of this Agreement that, by their nature, should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity, and limitations of liability.

Notification of Changes
Yuppie reserves the right to change these conditions from time to time as it sees fit and your continued use of the site will signify your acceptance of any adjustment to these terms. If there are any changes to our privacy policy, we will announce that these changes have been made on our home page and on other key pages and applications. As well, any changes to our privacy policy will be posted on our site 30 days prior to these changes taking place. You are therefore advised to re-read this statement on a regular basis.
""")
                    .font(.custom("Futura", size: 18))
                
            }.padding(.horizontal, 25)
        }
    }
}


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
Any participation in Nested’s services will constitute acceptance of this Agreement. By accessing and using Nested’s services you accept and agree to be bound by the terms and provisions of this Agreement. In addition, when using Nested’s services, you shall be subject to any posted guidelines or rules applicable to such services. Any participation in these services will constitute acceptance of this Agreement. If you do not agree to abide by these terms and conditions, please do not use this service.

Definitions:

“Tenants” are defined as users of Nested’s services who represent the building of their current residence for the purpose of referring others into their building or using any of Nested’s community services.

“Searchers” are defined as users of Nested’s services who use Nested to find an apartment. They may engage with Tenants and Clients.

“Clients” are defined as users of Nested’s services who list their properties and use Nested as a lead generation tool, analytics partner, and/or any other Nested service.

“Users” are defined as the combined group of Tenants, Searchers, and Clients.

“Services” are defined as the broad range of use cases for Nested’s platform between Tenants, Searchers, and Clients. Services may change, be updated, and/or reduced at the sole discretion of Nested.

“Terms” refer to the legally binding clauses of this document dictating the proper and improper use of Nested and all of its Services.

“Content” refers to any medium of information (image, video, text, audio) transmitted to the platform by any User or Nested and its representatives.

“Agreement” refers to the entirety of the text in this document.


Prohibited use for all Users

As a condition of use, you promise not to use the Services for any purpose that is unlawful or prohibited by these Terms, or any other purpose not reasonably intended by Nested. By way of example, and not as a limitation, you agree not to use the Services:

1.    To abuse, harass, threaten, impersonate, or intimidate any person;
2.    To post or transmit, or cause to be posted or transmitted, any Content that libelous, defamatory, obscene, pornographic, abusive, offensive, profane, or that infringes any copyright or other right of any person;
3.    To communicate with Nested representatives or other Users in an abusive or offensive manner;
4.    To post or view content that is not permitted under the laws of the jurisdiction where you use the Services.
5.    To post or transmit, or cause to be posted or transmitted, any Communication designed or intended to obtain password information from any Nested user;
6.    To create or transmit unwanted ‘spam’ to any person or any URL;
7.    To create multiple accounts for the purpose of fraudulently using any of Nested’s services.

Registration

Tenants represent their properties and may earn referral fees for bringing Searchers into their building. Tenants are verified by cross-referencing their provided phone number with the phone number on file with their property manager.

All users must submit in onboarding a verified phone number, first & last name, university attended if applicable, and their residency if applicable (required to be considered a “Tenant”).

Trademarks

Nested, and Nested graphics, logos, designs, and service names are registered trademarks, trademarks or trade dress of Nested. Nested’s trademarks and trade dress may not be used in connection with any product or service without the prior written consent of Nested.


Use guidelines for Searchers

Nested is a platform that allows apartment searchers to find apartments transparently through their peers. We may from time to time introduce new Services that broaden this scope. As a condition of use, you promise not to use the Services for any purpose that is unlawful or prohibited by these Terms, or any other purpose not reasonably intended by Nested. In addition to the prohibited use for all Users, specifically Searchers agree not to use the Services:

1.    To offer or market any services outside of the scope of Nested’s Services;
2.    Create multiple accounts for the purpose of ‘spamming’ or otherwise adversely affecting the workflow of Nested’s Clients and Tenants.




Use guidelines for Tenants
Nested is a platform that allows Tenants to represent their buildings and seamlessly drive referrals into their properties. Tenants are compensated by their property manager and/or owner either in the form of cash or rent credits for their role in doing so. Tenant compensation is determined by the property manager or owner. Nested may, from time to time, as dictated by the relationship with particular Clients, distribute the Client’s referral payment to a Tenant. Nested however is not and does not intend to be a real estate broker. Nested does not provide any Users with brokerage services, and is purely an advertising platform. All payments made to Tenants originate from the Client.  Nested requires a signed and formal agreement from all of its Clients that they agree to pay tenant referral fees in a timely and accurate fashion. In addition to the prohibited use for all Users, specifically Tenants agree not to use the Services:
1.    To represent a property they are not an existing tenant of;
2.    To misrepresent any part of their residence.

An important part of the Nested search experience is the responsiveness of Tenants. The order in which apartment searchers see Tenants on our platform is significantly influenced by the Tenant’s response time. Generally, Tenants with the strongest response times and quality of responses are ranked highest and tend to generate the most leads.

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
1.    Information We Collect

Registration
Whether you join Nested as an apartment searcher or a tenant, you provide data including your name, phone number, and profile picture. If you would like to represent your property as a tenant, you will be required to confirm your building address and apartment number – we use this information to verify your residency with your property manager before displaying you as a referring tenant on our platform. Your unit information will never be disclosed to any users or third parties. Apartment searchers who make contact to property managers are required to verify their email address. We recommend that current university students use their .edu email address for this process.

Profile
The only information visible to other users from your profile will be your profile picture and first name. Tenants have the option of receiving text messages to their provided phone number – this information is always masked to the apartment searcher.

Messaging and video tours
We collect and aggregate the messaging data on our platform. We do this for two reasons: 1) oversee quality control and 2) to run analytics which we use to both support our apartment search algorithm and property manager marketing decisions. We will never disclose an identified individual’s messages to a 3rd party, but we do aggregate messaging data.

2.    How Do We Collect Information?
Information That You Give Us
Typically, the information we collect directly from you comes through input forms such as our onboarding process as well as integrations with our property manager clients. As noted above, we use messaging data to optimize our apartment matching algorithm and support property managers in their sales process.

Information Collected Automatically
When you use or interact with our Site and Services, we receive and store information generated by your activity like usage data, and other information automatically collected from your browser or mobile device. This information may include your: IP address, browser type and version, preferred language, geographic location using IP address or GPS, wireless, or Bluetooth technology on your device, operating system and computer platform, the full Uniform Resource Locator (URL) clickstream to, through and from our Site, including date and time, products you viewed or searcher for, and areas of our Site and Services that you visited. We also may log the length of time of your visit and the number of times you visit and purchase or use the Services. We may assign you one or more unique identifiers to help keep track of your future visits.

In most cases, this information is generated by various tracking technologies. Tracking technologies may include “cookies”, “flash LSOs”, “web beacons” or “web bugs,” and “clear GIFs”.


Information from Other Sources
If we receive any information about you from other sources, we may add it to the information we already have about you.

What We Use Your Personal Information For
-    To provide Nested services to you;
-    Respond to your requests, inquiries, comments or concerns;
-    Enable you to personalize Nested services;
-    Notify you about changes or updates to Nested and other products and services, including those belonging to related third parties;
-    Provide you with special offers and other information about related events, products, and services and invite you to participate in surveys, competitions and promotions, as determined by your choices and communications preferences;
-    Evaluate and improve Nested and other products and services and to develop new products or services;
-    Identify and analyze usage trends and determine the effectiveness or our promotional campaigns;
-    Provide technical, product and other support and help keep <Nested> services working, safe and secure;
-    Comply with our legal obligations;

3.    Children Under the Age of 13
Our web and mobile applications are not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If you are 13, please do not provide any information on any of Nested’s services.

4.    Mailing Policy
When you send us an email, we use your email address to thank you for your comment and/or reply to your question, and we will store your communication and our reply for any future correspondence.

When you accept to receive information about our services, promotions, newsletters, press releases, and/or new offers, we use your email address and any other information you give us to provide you with the information or other services, until you ask to us to stop (using the ‘unsubscribe’ instructions provided with each email communication).

When you request information or other services from us, we use your email address and any other information you give us to provide you with the information or other services that you requested, until you ask us to stop (using the ‘unsubscribe’ instructions provided with each email, and/or on the site where you signed up, and / or as we otherwise provide), or until the information or service is no longer available.

We will never use your email address or other information to provide you with any unsolicited messages or information (unless that is part of the service you are requesting), nor will we share it with or sell, rent or lease it to any third party for such use.

5.    Business Transfers
If you have registered to use Nested and our services, we will not sell, rent, swap, or authorize any third party to use your email address without your permission.

In the future, we may sell, buy, merge or partner with other companies or businesses. In such transactions, we may include your information among transferred assets.

6.    Dispute Resolution
If you have any complaints regarding our compliance with this privacy policy, you should first contact us. We will investigate and attempt to resolve complaints and disputes regarding use and disclosure of personal information in accordance with this privacy policy.

7.    Future Changes to This Privacy Policy
We may update this Privacy Policy as necessary to reflect changes we make and to satisfy legal requirements. We will post a prominent notice of material changes on our websites. We will provide you with other appropriate notice of important changes at least 30 days before the effective date.

8.    Contact US

If you have a question about this privacy policy, you can contact Nested via +1 860-929-2559 or via U.S postal mail at Nested, LLC: 635 W 42nd Street Unit 40H, New York, New York, 10036.

""")
                    .font(.custom("Futura", size: 18))
                
            }.padding(.horizontal, 25)
        }
    }
}

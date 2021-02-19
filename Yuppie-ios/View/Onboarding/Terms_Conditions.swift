//
//  Terms_Conditions.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 28/11/1399 AP.
//


import SwiftUI

struct Terms_Conditions: View {
    

    @State var showVerification = false
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var token: String
    @Binding var user_id: String
    @State var maxWidth = UIScreen.main.bounds.width - 100
    @State var offset: CGFloat = 0
    @State var showCentralHomeView = false
    
    
    func toString(_ value: Any?) -> String {
      return String(describing: value ?? "")
    }
    
    var gradient1 = [Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    var gradient = [Color("gradient1"),Color("gradient2"),Color("gradient3"),Color("gradient4")]
    
    @StateObject var universityData = UniversityModel()
    
    
    func calculateWidth() -> CGFloat {
        let percent = offset / maxWidth
        return percent * maxWidth
        
    }
 
    func onChanged(value: DragGesture.Value){
        
        if value.translation.width > 0 && offset <= maxWidth - 65{
        offset = value.translation.width
        }
        
    }
    
    func onEnd(value: DragGesture.Value){
        withAnimation(Animation.easeOut(duration: 0.3)){
            if offset > 180 {
                offset = maxWidth - 65
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                NotificationCenter.default.post(name:
                                                    Notification.Name("Success"), object: nil)
                    self.send((Any).self)
                    self.didLogin = true
                                   self.needsAccount = false
                                   self.showCentralHomeView.toggle()
                }
                
                
                
            }
            else {
                offset = 0
            }
        }
    }
      
    public func send(_ sender: Any) {
       let parameters: [String: Bool] = ["terms": true]
       let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/users/"+self.user_id)! as URL)
         request.httpMethod = "PATCH"
       print(self.token)
       request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
       print("http://18.218.78.71:8080/users/"+self.user_id)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            print(dump(toString(request.httpBody)))

           } catch let error {
               print(error)
           }
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
           request.addValue("application/json", forHTTPHeaderField: "Accept")

            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                  guard error == nil else {
                          return
                      }

                      guard let data = data else {
                          return
                      }

                      do {
                          //create json object from data
                          if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                             print(json)
                           
                          }

                         let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                               responseString as! String
                      } catch let error {
                          print(error)
                      }
            }
            task.resume()
        

     }
    
    var body: some View {
        
        ZStack{
            
            NavigationLink(destination: CentralHomeView(token: $token, didLogin: $didLogin, needsAccount: $needsAccount, user_id: $user_id), isActive: self.$showCentralHomeView) {

                Text("")
            }
            
            
            VStack(spacing: 35){
                
               

           
                
                // Button.....
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                    
                    
                    
                    
                    VStack{
                        
                                ScrollView{
                                    VStack{
                                        
                                        Text("Terms and Conditions")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.white)
                                        Spacer()
                                        
                                      
                                        Text("""
                        (Yuppie, LLC) Terms and Conditions
                        
                        Any participation in Yuppie’s services will constitute acceptance of this Agreement. By accessing and using Yuppie’s services you accept and agree to be bound by the terms and provisions of this Agreement. In addition, when using Yuppie’s services, you shall be subject to any posted guidelines or rules applicable to such services. Any participation in these services will constitute acceptance of this Agreement. If you do not agree to abide by these terms and conditions, please do not use this service.
                        
                        Definitions:
                        
                        “Tenants” are defined as users of Yuppie’s services who represent the building of their current residence for the purpose of referring others into their building or using any of Yuppie’s community services.
                        
                        “Searchers” are defined as users of Yuppie’s services who use Yuppie to find an apartment. They may engage with Tenants and Clients.
                        
                        “Clients” are defined as users of Yuppie’s services who list their properties and use Yuppie as a lead generation tool, analytics partner, and/or any other relevant Yuppie service.
                        
                        “Users” are defined as the combined group of Tenants, Searchers, and Clients.
                        
                        “Services” are defined as the broad range of use cases for Yuppie’s platform between Tenants, Searchers, and Clients. Services may change, be updated, and/or reduced at the sole discretion of Yuppie.
                        
                        “Terms” refer to the legally binding clauses of this document dictating the proper and improper use of Yuppie and all of its Services.
                        
                        “Content” refers to any medium of information (image, video, text, audio) transmitted to the platform by any User.
                        
                        “Agreement” refers to the entirety of the text in this document.
                        
                        
                        Prohibited use for all Users
                        
                        As a condition of use, you promise not to use the Services for any purpose that is unlawful or prohibited by these Terms, or any other purpose not reasonably intended by Yuppie. By way of example, and not as a limitation, you agree not to use the Services:
                        
                        To abuse, harass, threaten, impersonate, or intimidate any person;
                        To post or transmit, or cause to be posted or transmitted, any Content that libelous, defamatory, obscene, pornographic, abusive, offensive, profane, or that infringes any copyright or other right of any person;
                        To communicate with Yuppie representatives or other Users in an abusive or offensive manner;
                        For any purpose (including posting or viewing Content) that is not permitted under the laws of the jurisdiction where you use the Services.
                        To post or transmit, or cause to be posted or transmitted, any Communication designed or intended to obtain password information from any Yuppie user;
                        To create or transmit unwanted ‘spam’ to any person or any URL;
                        To create multiple accounts for the purpose of fraudulently using any of Yuppie’s services.
                        
                        Registration
                        
                        Tenants represent their properties and may earn referral fees for bringing Searchers into their building. Tenants are verified by cross-referencing their provided phone number with the phone number on file with their property manager.
                        
                        Trademarks
                        
                        Yuppie, and Yuppie graphics, logos, designs, and service names are registered trademarks, trademarks or trade dress of Yuppie. Yuppie’s trademarks and trade dress may not be used in connection with any product or service without the prior written consent of Yuppie.
                        
                        
                        Suspension and Termination of Services
                        
                        By You
                        This clause applies when we charge Clients on a subscription basis to list their properties. In most cases, we simply continue to operate within the boundaries of a Client’s tenant referral plan. If a Client decides to terminate our services we will immediately cease recurring payments. All pending payments for non-subscription products and tenant referral fees must be paid by the Client. Immediately upon cancellation, the Client’s listings will be removed from the platform. The Client may request that listings remain on the platform for the remainder of the billing period. If the subscription was cancelled within a billing period, the remaining portion will not be refunded unless there was a material breach by Yuppie in executing the Terms of this Agreement.
                        
                        
                        By Yuppie
                        Yuppie reserves the right to remove listings and Clients from its platform. In the vast majority of cases, Yuppie exercises this right in response to fake, stale, fraudulent, or otherwise malicious listings. We will notify the Client of any infringements and allow for a 7-day grace period to correct the listing(s). If Yuppie decides to remove a Client from the platform as a whole, we will provide a 30-day written notice of our intention to do so.
                        
                        
                        
                        Use guidelines for Searchers
                        
                        Yuppie is a platform that allows apartment searchers to find apartments transparently through their peers. We may from time to time introduce new Services that broaden this scope. As a condition of use, you promise not to use the Services for any purpose that is unlawful or prohibited by these Terms, or any other purpose not reasonably intended by Yuppie. In addition to the prohibited use for all Users, specifically Searchers agree not to use the Services:
                        
                        To offer or market any services outside of the scope of Yuppie’s Services;
                        Create multiple accounts for the purpose of ‘spamming’ or otherwise adversely affecting the workflow of Yuppie’s Clients and Tenants.
                        
                        
                        Use guidelines for Tenants
                        Yuppie is a platform that allows Tenants to represent their buildings and seamlessly drive referrals into their properties. Tenants are compensated by their property manager and/or owner either in the form of cash or rent credits for their role in doing so. Tenant compensation is determined by the property manager or owner and Yuppie is not responsible for dispersing this payment. Yuppie requires a signed and formal agreement from all of its Clients that they agree to pay tenant referral fees in a timely and accurate fashion. In addition to the prohibited use for all Users, specifically Tenants agree not to use the Services:
                        To represent a property they are not an existing tenant of;
                        To misrepresent any part of their residence.
                        
                        An important part of the Yuppie search experience is the responsiveness of Tenants. The order in which apartment searchers see Tenants on our platform is significantly influenced by the Tenant’s response time. Generally, Tenants with the strongest response times and quality of responses are ranked highest and tend to generate the most leads.
                        
                        Use guidelines for Clients
                        Yuppie’s services are designed to fix many of the problems with traditional real estate lead generation. We strive to bring high quality, high-conversion value leads to communities and drive retention for our Clients. In addition to the prohibited use for all Users, specifically Clients agree not to use the Services:
                        To misrepresent their properties in any way;
                        Add fraudulent, stale, or otherwise misleading listing(s) or information;
                        Clients agree to pay referral rewards for all confirmed and closed leads originating from Yuppie. Yuppie bears the responsibility of notifying the Client of which Tenants to compensate, but the Client agrees to compensate the Tenant in the form of cash or rent credits within 30 days of notice from Yuppie.
                        
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
                        """).foregroundColor(Color("Color"))
                                        
                                    }.padding(.horizontal, 25)
                                    .padding(.top, 25)
                                    .padding(.bottom, 25)
                                }.background(Color("Color").opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius:20))
                                .frame(height: 500)
                                .padding()
                        
                                }
                        
                        
                        
                       
                       
                       
                       
                        Spacer()
                    
                    
                        
                        
                    }
                    
                )
                ZStack{
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                    
                    Text("Swipe to Agree")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading, 30)
                    HStack{
                    Capsule()
                        .fill(Color("Chat_color"))
                        .frame(width:calculateWidth() + 65)
                        
                        Spacer(minLength: 0)
                        
                    }
                    
                    HStack{
                        ZStack{
                            Image(systemName: "chevron.right")
                            
                            Image(systemName: "chevron.right")
                                .offset(x: -10)
                        }.foregroundColor(.white)
                        .offset(x:5)
                        .frame(width:65, height: 65)
                        .background(Color("red"))
                        .clipShape(Circle())
                        .offset(x: offset)
                        .gesture(DragGesture().onChanged(onChanged(value:))
                                    .onEnded(onEnd(value:)))
                        
                        Spacer()
                    }
                }.frame(width: maxWidth, height: 65)
                .padding(.bottom)
                .padding(.top,60)
                

            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
        
            ZStack{
                
                LinearGradient(gradient: .init(colors: gradient), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.1)
                    .ignoresSafeArea(.all, edges: .top)
            }
        )
    }
}



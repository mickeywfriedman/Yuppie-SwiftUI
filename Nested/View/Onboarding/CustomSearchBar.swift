//
//  CustomSearchBar.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 27/11/1399 AP.
//

import SwiftUI

struct CustomSearchBar: View {
    @ObservedObject var searchData: SearchUsers
    @State var rec = ""
    @State var show = false
    @State var showTermsandConditions = false
    @Binding var didLogin: Bool
    @Binding var needsAccount: Bool
    @Binding var token: String
    @Binding var user_id: String
    @State var buildings = [TestData.buildings[0]]
    @State var showUnit = false
    @State var buildingID = ""
    @State var Apartment = 0
    @State var showError = false
    @State var Apartments = ["Enter Unit (Optional)"]
    @Environment(\.colorScheme) var colorScheme
    func findApartments (buildingId: String) -> [String]{
        var result = ["Enter Unit (Optional)"]
        guard let url = URL(string: "http://18.218.78.71:8080/buildings/\(buildingId)/unit-numbers") else {
            print("Your API end point is Invalid")
            return result
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(self.token)
                if let urlresponse = try? JSONDecoder().decode(UnitResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.Apartments = urlresponse.result
                        result = urlresponse.result
                        print(Apartments)
                        self.Apartments.insert("Enter Unit (Optional)", at: 0)
                        print("success")
                    }
                    return
                }
                
            }
        }.resume()
        return result
    }
    func toString(_ value: Any?) -> String {
      return String(describing: value ?? "")
    }
    func filterBuildings() -> [Building] {
        var filtered = [TestData.buildings[0]]
        for building in buildings{
            if (((building.address.streetAddress.lowercased()).contains(searchData.query.lowercased())) || ((building.name.lowercased()).contains(searchData.query.lowercased()))) {
                filtered.append(building)
            }
        }
        filtered.removeFirst()
        return filtered
    }

    func loadData() {
        if (self.token != "") {
            print(self.token, "SUHSHHHS")
            guard let url = URL(string: "http://18.218.78.71:8080/buildings") else {
                print("Your API end point is Invalid")
                return
            }
            var request = URLRequest(url: url)
            request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
            print(self.token)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let response = try? JSONDecoder().decode(Response.self, from: data) {
                        DispatchQueue.main.async {
                            self.buildings = response.data
                            print("hello")
                            print(user_id)
                        }
                        return
                    }
                }
            }.resume()
        }
        }
    
    
    
    public func send() {
                
        self.showTermsandConditions.toggle()
        let parameters: [String: String] = ["user" : self.user_id, "unit": "\((Apartment == 0) ? "": Apartments[Apartment])"]

                  
                let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/buildings/\(buildingID)/tenants")! as URL)
                  request.httpMethod = "POST"
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
        
        
        ZStack{ NavigationLink(destination: Terms_Conditions(didLogin: $didLogin, needsAccount: $needsAccount, token: $token, user_id: $user_id), isActive: self.$showTermsandConditions) {
            
            Text("")
        }
        }
        VStack(spacing: 0){
            VStack(spacing: 0){
            HStack(spacing: 12){
                
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.white)
                TextField("The Atelier...", text: $searchData.query)
                    .autocapitalization(.none)
                if searchData.query != "" {
                    Image(systemName: "xmark.circle")
                        .onTapGesture {
                            showUnit = false
                            searchData.query = ""
                            Apartment = 0
                            Apartments = ["Enter Unit (Optional)"]
                        }
                }
            }.padding(.vertical, 10)
            .padding(.horizontal)
            
            if !searchData.query.isEmpty{
                ScrollView(.vertical, showsIndicators: true){
                    LazyVStack(alignment: .center){
                        if !showUnit{
                        ForEach(filterBuildings(), id: \.id){user in
                            VStack(alignment: .leading, spacing: 6){
                                Text("\(user.name)"+" - "+"\(user.address.streetAddress)")
                                    .foregroundColor(Color.white)
                                    .font(.custom("Futura", size: 16))
                                    .onTapGesture{
                                        searchData.query = user.name
                                        self.buildingID = user.id
                                        self.showUnit = true
                                        findApartments(buildingId: buildingID)
                                }
                                Divider()
                            }.padding(.horizontal,35).offset(y: 20)
                        }
                        if filterBuildings().count == 0 {
                            VStack(alignment: .center){
                            Text("We couldn't find your building😔")
                                .foregroundColor(Color.white)
                            Text("Submit your property manager below:")
                                .foregroundColor(Color.white)}
                                .offset(y: 35)
                            HStack(spacing: 15){
                                Spacer()
                                TextField("Code", text: self.$rec)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                                    .background(Color("pgradient1"))
                                    .clipShape(Capsule())
                                    
                                Spacer()
                            }
                            .frame(height: 100)
                            .offset(y: 15)
                        }
                        }
                        else {
                            VStack{
                                if Apartments.count != 1{
                                HStack(spacing: 15){
                                    Spacer()
                                    Picker(selection: $Apartment, label:
                                            Text(Apartments[Apartment])
                                ) {
                                    ForEach(0 ..< Apartments.count) {
                                        Text(self.Apartments[$0])
                                    }
                                    .padding(1.0)
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }.pickerStyle(MenuPickerStyle())
                                        
                                    Spacer()
                                }
                                } else {
                                    Text("")
                                }
                            Button(action: {
                                
                                
                                self.send()
                            }) {
                                
                                Text("Submit")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .font(.custom("Futura", size: 18))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 45)
                                    .background(Color("pgradient1"))
                                    .clipShape(Capsule())
                            }
                            }.offset(y:15)
                            
                        }
                    Spacer()
                    }.frame(height: 100)
                    
                }
            } else {
                VStack{
                    Text("")
                }.frame(height: 135)
                .offset(y: 15)
            }
        }.background(Color("Color").opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius:20))
        .frame(height: 180)
        .padding()
    }.onAppear(perform: loadData)
        Button(action: {
//
                        self.showTermsandConditions.toggle()
                        
                    }) {
                        
                        Text("Not a Nested Resident (Yet)")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .font(.custom("Futura", size: 18))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 45)
                            .background(Color("pgradient1"))
                            .clipShape(Capsule())
                    }
        Text("Disclaimer: We will never share unit information. Adding your unit allows us to help you pass down furniture.")
            .multilineTextAlignment(.center)
                    // disabling view when both textfields are empty...
//                    .opacity((self.address == "") ? 0.65 : 1)
//                    .disabled(( self.address == "") ? true : false).offset(y: 70)
                    
        
    }
    
    
}

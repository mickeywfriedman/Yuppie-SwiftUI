//
//  BuildingGallery.swift
//  Yuppie-ios
//
//  Created by Mickey Friedman on 11/11/1399 AP.
//
import SwiftUI

struct BuildingGallery: View {
    @State var query = ""
    var buildings: [Building]
    @Binding var user: User
    @State var rec = ""
    @State var showUnit = false
    @State var buildingID = ""
    @State var filter = ""
    var token : String
    @State var Apartment = 0
    @State var Apartments = ["Enter Unit"]
    @State var showError = false
    @Environment(\.colorScheme) var colorScheme
    func findApartments (buildingId: String) -> [String]{
        var result = ["Enter Unit"]
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
                        self.Apartments.insert("Enter Unit", at: 0)
                        print("success")
                    }
                    return
                }
                
            }
        }.resume()
        return result
    }

    public func send() {
        if Apartment == 0{
            showError = true
        }
        else{
        user.building = filterBuildings()[0].id
        let parameters: [String: String] = ["user" : self.user.id, "unit": Apartments[Apartment]]
                  
                let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/buildings/\(buildingID)/tenants")! as URL)
                  request.httpMethod = "POST"
            request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
               
        print("http://18.218.78.71:8080/users/"+self.user.id)
             
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
             }
    public func removeResidency() {
        showUnit = false
        query = ""
        Apartments = ["Enter Unit"]
        Apartment = 0
        let parameters: [String: String] = ["user" : self.user.id]
                  
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.218.78.71:8080/buildings/\(user.building)/tenants")! as URL)
                  request.httpMethod = "DELETE"
        request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
             
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
        user.building = ""
        
    }
    func filterBuildings() -> [Building] {
        var filtered = [TestData.buildings[0]]
        for building in buildings{
            if (((building.address.streetAddress.lowercased()).contains(filter.lowercased())) || ((building.name.lowercased()).contains(filter.lowercased()))) {
                filtered.append(building)
            }
        }
        filtered.removeFirst()
        print(filter)
        return filtered
    }
    func toString(_ value: Any?) -> String {
      return String(describing: value ?? "")
    }
    func getImages() -> [String] {
        for building in buildings {
            if building.id == user.building{
                return building.images
            }
        }
        return []
    }
    func getBuilding() -> String{
        for building in buildings {
            if building.id == user.building{
                return building.name
            }
        }
        return ""
    }
    var columns = Array(repeating: GridItem(.flexible(),spacing: 20), count: 2)
    var body: some View {
        if getImages().count == 0 {
            VStack(spacing: 0){
                VStack(spacing: 0){
                HStack(spacing: 12){
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                    TextField("The Atelier...", text: self.$query)
                        .onChange(of: query, perform: { value in
                            self.filter = value
                        })
                        .autocapitalization(.none)
                    if query != "" {
                        Image(systemName: "xmark.circle")
                            .onTapGesture {
                                showUnit = false
                                query = ""
                                Apartments = ["Enter Unit"]
                                Apartment = 0
                            }
                    }
                }.padding(.vertical, 10)
                .padding(.horizontal)
                
                if !query.isEmpty{
                    ScrollView(.vertical, showsIndicators: true){
                        LazyVStack(alignment: .center){
                            if !showUnit{
                            ForEach(filterBuildings(), id: \.id){building in
                                VStack(alignment: .leading, spacing: 6){
                                    Text("\(building.name)"+" - "+"\(building.address.streetAddress)")
                                        .font(.custom("Futura", size: 16))
                                        .onTapGesture{
                                            query = building.name
                                            self.buildingID = building.id
                                            findApartments(buildingId: building.id)
                                            self.showUnit = true
                                    }
                                    Divider()
                                }.padding(.horizontal,35).offset(y: 20)
                            }
                            if filterBuildings().count == 0 {
                                VStack(alignment: .center){
                                Text("We couldn't find your building😔")
                                Text("Submit your property manager below:")
                                    }
                                    .offset(y: 35)
                                HStack(spacing: 15){
                                    Spacer()
                                    TextField("Code", text: self.$rec)
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
                                    if Apartments.count > 1 {
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
                                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                        .font(.custom("Futura", size: 18))
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 45)
                                        .background(Color("pgradient1"))
                                        .clipShape(Capsule())
                                }
                                    if showError{
                                        Text("Please Enter Your Unit Above")
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
        }
        } else {
        ScrollView{
            Text("\(getBuilding())")
            Button(action: {
                self.removeResidency()
                
            }) {
                
                Text("Remove Residency")
                    .font(.custom("Futura", size: 18))
                    .foregroundColor(Color.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 45)
                    
                    .background(Color("tabbar"))
                    .clipShape(Capsule())
            }
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
        .padding(.horizontal)
        .padding(.top)
        }
            // padding miniplayer size as bottom...
            //.padding(.bottom,80)
        }
        }

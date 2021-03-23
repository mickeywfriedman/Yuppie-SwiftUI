//
//  Sheets.swift
//  Yuppie-ios
//
//  Created by Ryan Cao on 2/27/21.
//

import SwiftUI

struct sheets: View {
    @Binding var card: String
    @Binding var showCard : Bool
    @Binding var user: User
    @State var buildings: [Building]
    @Binding var user_id: String
    @Binding var token: String
    @Binding var index: Int
    @State var minDate = Date()
    @State var maxDate = Date(timeInterval: 14*86400, since: Date())
    @Binding var tenant_id : String
    @Binding var tenant_prof : String
    @Binding var tenant_name : String
    func filter(units: [Unit], buildingAmenities: [String]) -> Bool{
        for unit in units{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date_avail = dateFormatter.date(from: unit.dateAvailable)
            if (unit.bedrooms >= user.preferences.bedrooms && unit.bathrooms-1 >= user.preferences.bathrooms && Int(unit.price) <= Int(user.preferences.price) && date_avail ?? Date() < dateFormat(string: user.preferences.latestMoveInDate)){
                for amenity in user.preferences.amenities {
                    if (!buildingAmenities.contains(amenity)){
                        return false
                    }
                }
                return true
            }
        }
        return false
    }
    func filteredBuildings() -> [Building]{
        return buildings.filter({filter(units: $0.units, buildingAmenities:$0.amenities)})
    }
    func dateFormat(string : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string) ?? Date()
    }
    func reset() -> Void {
        index = 0    }

    func format(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    func updateFilters() -> Void {
        self.user.preferences.earliestMoveInDate = "\(format(date: minDate))"
        self.user.preferences.latestMoveInDate = "\(format(date: maxDate))"
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
        print("updated")
        URLSession.shared.dataTask(with: filter_request) { data, response, error in
            return
            
        }.resume()
    }
    func unitFilter(unit: Unit) -> Bool{
        if (unit.bedrooms >= user.preferences.bedrooms && unit.bathrooms >= user.preferences.bathrooms){
                return true
            }
            return false
        }
    
    func minBeds () -> Int{
        var lowest = 3
        for unit in buildings[index].units.filter({unitFilter(unit:$0)}) {
            if (Int(unit.bedrooms) < lowest){
                lowest = unit.bedrooms
            }
        }
        return lowest
    }
    var body: some View {
        if (card == "filter"){
        VStack{
            Text("Update Preferences").font(.largeTitle).fontWeight(.heavy)
        FiltersView(token: $token, user: $user, user_id: $user_id, minDate: dateFormat(string: user.preferences.earliestMoveInDate), maxDate: dateFormat(string: user.preferences.latestMoveInDate)).onDisappear(perform: updateFilters)
        }.padding().onDisappear(perform: {
            reset()
        })
        }
        else if (card == "building") {
            BuildingView(Bedroom: minBeds(), user : $user, token: $token, user_id: $user_id, building:filteredBuildings()[index])
        }
        else if (card == "inbox") {
            Inbox(token: $token, user_id: $user_id, user: $user)
        }
        else if (card == "chat") {
            ChatUI(token: $token, user_id: $user_id, tenant_id: $tenant_id, tenant_prof: $tenant_prof, tenant_name: $tenant_name, showChatUI: $showCard)
        } else {
            Text("oops")
        }
        }
}

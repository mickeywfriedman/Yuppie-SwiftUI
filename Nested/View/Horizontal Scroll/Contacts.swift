//
//  Contacts.swift
//  Nested
//
//  Created by Ryan Cao on 3/24/21.
//

import SwiftUI
import Contacts
import MessageUI

struct SearchBarView: UIViewRepresentable {

    @Binding var text: String
    var placeholder: String

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.showsCancelButton = true
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar,
                      context: Context) {
        uiView.text = text
    }
}
class Coordinator: NSObject, UISearchBarDelegate {

    @Binding var text: String

    init(text: Binding<String>) {
        _text = text
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        text = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}



extension CNContact: Identifiable {
    var name: String {
        return [givenName, familyName].filter{ $0.count > 0}.joined(separator: " ")
    }
}
class ViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
struct Contacts: View {
    @State var user : User
    @State var contacts: [CNContact] = []
    @State var error: Error? = nil
    func messageComposeViewController(controller: MFMessageComposeViewController,
                                      didFinishWithResult result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)}
    func invite(number: String) {
        print(number)
        let composeVC = MFMessageComposeViewController()
        // Configure the fields of the interface.
        composeVC.recipients = [number]
        composeVC.body = "https://apps.apple.com/app/id1556148411?fbclid=IwAR3UoH0Tz8A9EiPGvaFIZwqZxRdevMQKYaL5JFvh-bzWe1yzRhM2FBmNOWk"
        composeVC.present(composeVC, animated: true, completion: nil)
    }
     func fetchContacts() {
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            
            if granted {

                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                request.sortOrder = .givenName
                
                do {

                    var contactsArray = [CNContact]()
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        if (contact.phoneNumbers.first?.value.stringValue) != nil{
                            contactsArray.append(contact)
                        }
                    })
                    
                    self.contacts = contactsArray
                    
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
    @State private var searchText : String = ""

    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(text: $searchText, placeholder: "Type here")
                List{
                    
                    ForEach(self.contacts.filter{
                        self.searchText.isEmpty ? true : $0.givenName.lowercased().contains(self.searchText.lowercased())
                    }, id: \.self.name) {
                        (contact: CNContact) in
                        
                        HStack{
                            Text(contact.name).font(.headline)
                            Spacer()
                            Text("Invite")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color("pgradient1"))
                                .clipShape(Capsule())
                                .onTapGesture {
                                    invite(number: contact.phoneNumbers.first!.value.stringValue)
                                }
                        }
                        
                    }
                }.onAppear{
                    DispatchQueue.main.async {
                        fetchContacts()
                    }
                }
                .navigationBarTitle(Text("SwiftUI Contacts"))
            }
        }
    }
}

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
        switch (result) {
            case .cancelled:
                print("Message was cancelled")
                dismiss(animated: true, completion: nil)
            default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
struct MessageComposeView: UIViewControllerRepresentable {
    typealias Completion = (_ messageSent: Bool) -> Void

    static var canSendText: Bool { MFMessageComposeViewController.canSendText() }
        
    @Binding var recipients: [String]
    @State var body: String
    @State var completion: Completion?
    
    func makeUIViewController(context: Context) -> UIViewController {
        print(recipients)
        guard Self.canSendText else {
            let errorView = MessagesUnavailableView(recipients: recipients)
            return UIHostingController(rootView: errorView)
        }
        
        let controller = MFMessageComposeViewController()
        controller.messageComposeDelegate = context.coordinator
        controller.recipients = recipients
        controller.body = body
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(completion: self.completion)
    }
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        private let completion: Completion?

        public init(completion: Completion?) {
            self.completion = completion
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch (result) {
                case .cancelled:
                    print("Message was cancelled")
                    controller.dismiss(animated: true, completion: nil)
                default:
                break
            }
        }    }
}

struct MessagesUnavailableView: View {
    @State var recipients : [String]
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                .font(.system(size: 64))
                .foregroundColor(.red)
            Text(recipients[0] ?? "")
                .font(.system(size: 24))
        }
    }
}
struct Contacts: View {
    @State var user : User
    @State var contacts: [CNContact] = []
    @State var error: Error? = nil
    @State private var isShowingMessages = false
    @State var recipients: [String] = []
    let message = "https://apps.apple.com/app/id1556148411"
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
                    .sheet(isPresented: self.$isShowingMessages) {
                        MessageComposeView(recipients: $recipients, body: "https://apps.apple.com/app/id1556148411") { messageSent in
                                    print("MessageComposeView with message sent? \(messageSent)")
                                }
                    }
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
                                    self.recipients = [contact.phoneNumbers.first?.value.stringValue ?? ""]
                                    let seconds = 0.1
                                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                        self.isShowingMessages = true
                                    }
                                    
                                }
                        }
                        
                    }
                }.onAppear{
                    DispatchQueue.main.async {
                        fetchContacts()
                    }
                }
                .navigationBarTitle(Text("Invite Contacts"))
            }
        }
    }
}

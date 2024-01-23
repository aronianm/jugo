//
//  ContactListView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI
import ContactsUI

struct ContactListView: View {
    var authViewModel: AuthenticationViewModel
    @State private var searchText = ""
    @State private var contacts: [CNContact] = []
    
    var filteredContacts: [CNContact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { contact in
                contact.givenName.localizedCaseInsensitiveContains(searchText) ||
                contact.familyName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
                    VStack {
                        HStack {
                                    TextField("Search", text: $searchText)
                                        .padding(8)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(8)
                                    Button(action: {
                                        self.searchText = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 8)
                                }
                        List(filteredContacts, id: \.identifier) { contact in
                            NavigationLink(destination: CreateMatchView(contact: contact, authViewModel: authViewModel)) {
                                Text("\(contact.givenName) \(contact.familyName)")
                            }
                        }
                    }
                    .onAppear {
                       loadContacts()
                        
                    }
                }
    }
    
    func loadContacts() {
        let store = CNContactStore()

        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]

            let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])

            do {
                try store.enumerateContacts(with: request) { contact, _ in
                    if contact.givenName != "" && !contacts.contains(contact){
                        contacts.append(contact)
                    }
                }
                contacts.sort(by: { $0.givenName < $1.givenName })
            } catch {
                print("Error fetching contacts: \(error)")
            }
        } else {
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    loadContacts()
                } else {
                    print("Access to contacts denied.")
                }
            }
        }
    }
}

#Preview {
    ContactListView(authViewModel: AuthenticationViewModel())
}

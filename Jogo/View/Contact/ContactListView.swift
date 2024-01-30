//
//  ContactListView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI
import ContactsUI

struct ContactListView: View {
    @State private var isSheetPresented = false
    @StateObject var authViewModel: AuthenticationViewModel
    @StateObject var matchupManager: MatchupManager
    @State private var searchText = ""
    @State private var contacts: [CNContact] = []
    @State var showContact = true
    @Binding var shouldNavigateBack:Bool
    @State var activeContact:CNContact?
    
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
                            }.sheet(isPresented: $isSheetPresented) {
                                CreateMatchView(contact: activeContact!, 
                                                authViewModel: authViewModel,
                                                matchupManager: matchupManager,
                                                shouldNavigateBack: $shouldNavigateBack,
                                                isSheetPresented: $isSheetPresented
                                )
                            }
                            List(filteredContacts, id: \.identifier) { contact in
                                Text("\(contact.givenName) \(contact.familyName)").onTapGesture {
                                    matchupManager.isChallengeSent = true
//                                    shouldNavigateBack = false
                                    activeContact = contact
                                    isSheetPresented = true
                                }
                            }
                                            
                        }.onAppear {
                            loadContacts()
                         }
                    
                }
    }
    
    func loadContacts() {
        let store = CNContactStore()

        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactImageDataAvailableKey, CNContactThumbnailImageDataKey]

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


struct ContactListView_Previews: PreviewProvider {
    class MockAuthenticationViewModel: AuthenticationViewModel {
        
    }

    static var previews: some View {
        @ObservedObject var mockAuthModel = MockAuthenticationViewModel()
        mockAuthModel.login(phone_number: "978-726-5882", password: "looser67")

        @State var shouldNavigateBack:Bool = false
        return NavigationView {
            ContactListView(authViewModel: mockAuthModel,
                            matchupManager: MatchupManager(), shouldNavigateBack: $shouldNavigateBack)
        }
        
    }
}

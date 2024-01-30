//
//  AppView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct AppView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    @StateObject var matchupManager = MatchupManager()
    @State private var selectedOption = 0
    @State private var showDropdown = false
    @State private var isLogoutAlertPresented = false

    var body: some View {
        NavigationView {
            VStack {
                // Content based on user authentication status
                if authViewModel.user != nil {
                    // Add HistoryView content here
                    HistoryView(matchupManager: matchupManager)
                    // Add MatchupsView content here
                    MatchupsView(authViewModel: authViewModel,
                                 matchupManager: matchupManager)
                } else {
                    // Display when the user is not authenticated
                    ProgressView("Loading...")
                }
            }
            .onAppear {
                // Fetch data or perform other setup actions
                fetchData()
                if authViewModel.user == nil {
                    authViewModel.handleLoginSuccess()
                }
            }
            .toolbar {
                // Fancy toolbar items
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "star.fill") // Replace with your preferred SF Symbol
                        Text("Leaders")
                    }
                    .foregroundColor(ColorTheme.white) // Use your accent color
                    .onTapGesture {
                        // Handle menu button action
                    }
                }
                
                ToolbarItem() {
                                    Button(action: {
                                        showDropdown.toggle()
                                    }) {
                                        HStack{
                                            Text("Invitations")
                                            Image(systemName: "list.clipboard.fill")
                                        }
                                        
                                    }
                                    .popover(isPresented: $showDropdown, arrowEdge: .bottom) {
                                        ChallengeListView(matchupManager: matchupManager)
                                    }
                                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("Logout")
                        Image(systemName: "power") // Replace with your preferred SF Symbol for power/logout
                    }
                    .foregroundColor(.red) // Use a bold color for logout
                    .onTapGesture {
                        isLogoutAlertPresented = true
                    }
                }
            }
            .alert(isPresented: $isLogoutAlertPresented) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(
                        Text("Logout")
                            .foregroundColor(.white),
                        action: {
                            // Handle logout action
                            authViewModel.logout()
                        }
                    ),
                    secondaryButton: .cancel(
                        Text("Cancel")
                            .foregroundColor(.blue)
                    )
                )
            
            }.background(ColorTheme.background)
        }
    }


     private func fetchData() {
         // Perform data fetching using matchupManager
         matchupManager.authToken = authViewModel.authToken
         matchupManager.findAllMatchups()
     }
 }

struct ContentView_Previews: PreviewProvider {
    class MockAuthenticationViewModel: AuthenticationViewModel {
        
    }

    static var previews: some View {
        @ObservedObject var mockAuthModel = MockAuthenticationViewModel()
        mockAuthModel.login(phone_number: "978-726-5882", password: "looser67")

        return AppView(authViewModel: mockAuthModel)
        
    }
}

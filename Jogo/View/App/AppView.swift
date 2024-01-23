//
//  AppView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct AppView: View {
    var authViewModel: AuthenticationViewModel
    @StateObject var matchupManager = MatchupManager()
     
     @State private var matchups: [Matchup] = []

     var body: some View {
         NavigationView {
             VStack {
                 // Content based on user authentication status
                 if authViewModel.user != nil {
                     // Display when the user is authenticated
                     Text("Welcome \(authViewModel.user!.formattedName())")
                     // Add HistoryView content here
                     HistoryView()
                     // Add MatchupsView content here
                     MatchupsView(authViewModel: authViewModel, matchups: matchups)
                 } else {
                     // Display when the user is not authenticated
                     ProgressView("Loading...")
                 }
             }
             .onAppear {
                 // Fetch data or perform other setup actions
                 fetchData()
             }
             .toolbar {
                 // Toolbar items
                 ToolbarItem(placement: .navigationBarLeading) {
                     Button("Leaders") {
                         // Handle menu button action
                     }
                 }
                 
                 ToolbarItem(placement: .navigationBarTrailing) {
                     Button("Logout") {
                         authViewModel.logout()
                     }
                 }
             }
         }
     }

     private func fetchData() {
         // Perform data fetching using matchupManager
         matchupManager.userToken = authViewModel.authToken
         matchupManager.findAllMatchups { result in
             switch result {
             case .success(let fetchedMatchups):
                 self.matchups = fetchedMatchups
             case .failure(let error):
                 print("Error: \(error.localizedDescription)")
                 authViewModel.logout()
             }
         }
     }
 }

struct ContentView_Previews: PreviewProvider {
    class MockAuthenticationViewModel: AuthenticationViewModel {
        
    }

    static var previews: some View {
        let mockAuthModel = MockAuthenticationViewModel()
        mockAuthModel.login(phone_number: "978-726-5882", password: "looser67")

        return NavigationView {
            AppView(authViewModel: mockAuthModel)
        }
    }
}

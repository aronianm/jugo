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
    @StateObject var leagueManager = LeagueManager()
    
    @State private var code:String = ""
    @State private var selectedOption = 0
    @State private var showDropdown = false
    @State private var isLogoutAlertPresented = false
    @State private var loading:Bool = true
    @State private var showCode:Bool = false
    @State private var showCreateLeague:Bool = false
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                if authViewModel.user != nil && !loading {
                    if(leagueManager.league != nil){
//                        HistoryView(matchupManager: matchupManager)
//                        MatchupsView(authViewModel: authViewModel,
//                                         matchupManager: matchupManager)
                    }else{
                        HStack{
                            Image("Logo")
                                .resizable()
                                .cornerRadius(20)
                                .frame(width: 50, height: 50)
                                .padding()
                            if(leagueManager.leagues.count == 0){
                                Text("Welcome to Jogo")
                                    .foregroundColor(ColorTheme.white)
                                    .font(.title)
                                
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        showCreateLeague = true
                                        showCode = false
                                        code = ""
                                    }) {
                                        Text("Create a League")
                                            .padding()
                                            .background(ColorTheme.secondary)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    .padding()
                                    
                                    Button(action: {
                                        showCreateLeague = false
                                        showCode = true
                                        code = ""
                                    }) {
                                        Text("Join a League")
                                            .padding()
                                            .background(ColorTheme.primary)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    .padding()
                                    Spacer()
                                }
                            }
                    }
                        Spacer()
                        
                        
                        if(showCode){
                            CodeLeagueView(code: $code)
                        }else if(showCreateLeague){
                            CreateLeagueView(leagueManager: leagueManager)
                        }else{
                            LeagueListView(leagueManager: leagueManager)
                        }
                        
                    }
                } else {
                    // Display when the user is not authenticated
                    ProgressView("Loading...")
                }
                Spacer()
            }
            .onAppear {
                // Fetch data or perform other setup actions
                fetchData()
                if authViewModel.user == nil {
                    authViewModel.handleLoginSuccess()
                    leagueManager.getLeagues()
                }
            }
            .toolbar {
                if(leagueManager.leagues.count > 0){
                    ToolbarItem(placement: .bottomBar) {
                        HStack(spacing: 0) {
                            VStack {
                                Image(systemName: "person.line.dotted.person")
                                    .foregroundColor(selectedTab == 0 ? .blue : .gray) // Highlight if selected
                                Spacer()
                                Text("Leagues")
                                    .foregroundColor(selectedTab == 0 ? .blue : .gray) // Highlight if selected
                                    .onTapGesture {
                                        selectedTab = 0
                                        showCreateLeague = false
                                        showCode = false
                                    }
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "rectangle.center.inset.filled.badge.plus")
                                    .foregroundColor(selectedTab == 1 ? .blue : .gray) // Highlight if selected
                                Spacer()
                                Text("Create a League")
                                    .foregroundColor(selectedTab == 1 ? .blue : .gray) // Highlight if selected
                                    .onTapGesture {
                                        selectedTab = 1
                                        showCreateLeague = true
                                        showCode = false
                                    }
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "link.badge.plus")
                                    .foregroundColor(selectedTab == 2 ? .blue : .gray) // Highlight if selected
                                Spacer()
                                Text("Join a League")
                                    .foregroundColor(selectedTab == 2 ? .blue : .gray) // Highlight if selected
                                    .onTapGesture {
                                        selectedTab = 2
                                        showCreateLeague = false
                                        showCode = true
                                    }
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("Logout")
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
         Task {
//             matchupManager.findAllMatchups()
//             leagueManager.findLeague { league in
//                 
//             }
             loading = false
         }
         
     }
 }

struct ContentView_Previews: PreviewProvider {
    
    class MockAuthenticationViewModel: AuthenticationViewModel {
        
    }

    static var previews: some View {
        @ObservedObject var mockAuthModel = MockAuthenticationViewModel()
        mockAuthModel.login(phone_number: "978-726-5882", password: "looser67") { error in
        }

        return AppView(authViewModel: mockAuthModel)
        
    }
}

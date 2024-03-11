//
//  AppView.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct AppView: View {
    @StateObject var gameCenterManager: GameCenterManager

    @StateObject var leagueManager: LeagueManager = LeagueManager()
    
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
                    VStack{
                        if(showCode){
                            CodeLeagueView(leagueManager: leagueManager, showCode: $showCode)
                        }else if(showCreateLeague){
                            CreateLeagueView(leagueManager: leagueManager, showCreateLeague: $showCreateLeague)
                        }else{
                            if(leagueManager.leagues.count == 0){
                                VStack{
                                        Text("""
                                        Click on 'Create a League' and start competing against users
                                        
                                        
                                        Click on 'Join a League' and paste the code from an existing league to join
                                        """)
                                            .lineLimit(nil).multilineTextAlignment(.leading)
                                        
                                    }
                            }
                            LeagueListView(leagueManager: leagueManager).refreshable {
                                leagueManager.getLeagues()
                            }
                        }
                    }.onAppear {
                        leagueManager.getLeagues()
                    }
                    Spacer()
                    
                Spacer()
            }
            .toolbar {
                if(leagueManager.leagues.count > 0 || showCode == true || showCreateLeague == true){
                    ToolbarItem(placement: .bottomBar) {
                        HStack(spacing: 0) {
                            if(leagueManager.leagues.count > 0){
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
                            }else if(leagueManager.leagues.count == 0 && (showCode == true || showCreateLeague == true)) {
                                VStack {
                                    Image(systemName: "arrowshape.backward.fill")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("Back")
                                        .foregroundColor(.gray)
                                        .onTapGesture {
                                            showCreateLeague = false
                                            showCode = false
                                        }
                                }
                                Spacer()
                            }
                            VStack {
                                Image(systemName: "rectangle.center.inset.filled.badge.plus")
                                    .foregroundColor(showCreateLeague ? .blue : .gray) // Highlight if selected
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
                                    .foregroundColor(showCode  ? .blue : .gray) // Highlight if selected
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
                ToolbarItem(placement: .navigationBarLeading){
                    Image("Logo")
                        .resizable()
                        .cornerRadius(20)
                        .frame(width: 50, height: 50)
                        .padding()
                }
            }
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

        return AppView(gameCenterManager: GameCenterManager(), leagueManager:LeagueManager())
        
    }
}

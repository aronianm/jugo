//
//  ContentView.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authViewModel:AuthenticationViewModel
    @StateObject var matchupManager:MatchupManager
    @StateObject var leagueManager:LeagueManager
    var body: some View {
        Group {
            if(authViewModel.isLoggedIn){
                AppView(authViewModel: authViewModel, matchupManager:matchupManager, leagueManager:leagueManager)
            }else{
                LoginView(authViewModel: authViewModel)
            }
            
        }.background(ColorTheme.background)
    }
}

#Preview {
    ContentView(authViewModel: AuthenticationViewModel(), matchupManager: MatchupManager(), leagueManager:LeagueManager())
}

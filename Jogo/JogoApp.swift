//
//  JogoApp.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI


@main
struct JogoApp: App {
    @State var splash:Bool = true
    @ObservedObject var authViewModel = AuthenticationViewModel()
    @StateObject var matchupManager = MatchupManager()
    @StateObject var leagueManager = LeagueManager()
    var body: some Scene {
        WindowGroup {
            VStack{
                if(splash){
                    SplashScreen()
                }else{
                    ContentView(authViewModel: authViewModel, matchupManager:matchupManager, leagueManager:leagueManager)
                }
            }.onAppear {
                // Show splash screen for 2 seconds before transitioning to main content
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    splash = false
                    
                }
                if(authViewModel.isLoggedIn){
                    leagueManager.getLeagues()
                }
            }
            
                
        }
    }
}

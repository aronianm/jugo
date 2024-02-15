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
    @State private var splashScreenOffsetY: CGFloat = 0
    var body: some Scene {
        WindowGroup {
            VStack {
                if splash {
                    SplashScreen()
                        .offset(y: splashScreenOffsetY)
                        .animation(.easeInOut(duration: 0.5)) // Animation for sliding up
                } else {
                    ContentView(authViewModel: authViewModel, matchupManager: matchupManager, leagueManager: leagueManager)
                }
            }
            .onAppear {
                // Show splash screen for 2 seconds before transitioning to main content
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        splashScreenOffsetY = -UIScreen.main.bounds.height // Slide up
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        splash = false // Set splash to false after sliding animation
                    }
                }
                if authViewModel.isLoggedIn {
                    leagueManager.getLeagues()
                }
            }
        }
    }
}

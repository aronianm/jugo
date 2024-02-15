//
//  JogoApp.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI
import BackgroundTasks

@main
struct JogoApp: App {
    @State var splash:Bool = true
    @ObservedObject var authViewModel = AuthenticationViewModel()
    @StateObject var matchupManager = MatchupManager()
    @StateObject var leagueManager = LeagueManager()
    @State private var splashScreenOffsetY: CGFloat = 0
    let backgroundTaskIdentifier = "com.jensunset.Jogo.refreshData"
    
    
    init() {
        registerBackgroundTask()
    }
    
    
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
    
    func registerBackgroundTask() {
        // Register background task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundTaskIdentifier, using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        // Schedule background task
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 20) // Refresh every 15 minutes
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }
    func handleAppRefresh(task: BGAppRefreshTask) {
            task.expirationHandler = {
                print("Not Refreshing")
            }
            
            
            refreshData(completion: {
                task.setTaskCompleted(success: true)
            })
        }
        
    func refreshData(completion: @escaping () -> Void) {
        print("Refreshing")
            if authViewModel.isLoggedIn {
                leagueManager.getLeagues()
                for league in leagueManager.leagues {
                   matchupManager.refreshMatchups(id: league.id)
                }
                completion()
            }
       }
}

//
//  FogoApp.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI
import BackgroundTasks

@main
struct FogoApp: App {
    @State var splash:Bool = true
    @ObservedObject var gameCenterManager = GameCenterManager()
    @StateObject var leagueManager = LeagueManager()
    @State private var splashScreenOffsetY: CGFloat = 0
    let backgroundTaskIdentifier = "com.jensunset.Fogo.refreshData"
    
    
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
                    ContentView(gameCenterManager: gameCenterManager, leagueManager: leagueManager)
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
                if gameCenterManager.isAuthenticated {
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
//            if gameCenterManager.isAuthenticated {
//                leagueManager.getLeagues()
//                for league in leagueManager.leagues {
//                   matchupManager.refreshMatchups(id: league.id)
//                }
//                completion()
//            }
       }
}

//
//  ContentView.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gameCenterManager:GameCenterManager
    @ObservedObject var leagueManager:LeagueManager
    var body: some View {
        Group {
            if(gameCenterManager.isAuthenticated){
                AppView(gameCenterManager: gameCenterManager, leagueManager:leagueManager)
            }
            
        }.background(ColorTheme.background)
    }
}

#Preview {
    ContentView(gameCenterManager: GameCenterManager(), leagueManager:LeagueManager())
}

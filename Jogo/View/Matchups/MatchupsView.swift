//
//  MatchupsView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI

struct MatchupsView: View {
    var id: Int
    @StateObject var matchupManager: MatchupManager
    @State private var currentMatchupIndex: Int = 0

    var body: some View {
        VStack { // Set alignment to leading
            Text("Matchups")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.blue) // Replace with your primary color
            
            HStack {
                Button("Previous Matchup") {
                    if currentMatchupIndex > 0 {
                        currentMatchupIndex -= 1
                    }
                }
                .disabled(currentMatchupIndex == 0) // Disable button if on the first matchup
                
                Spacer()
                
                Button("Next Matchup") {
                    if currentMatchupIndex < matchupManager.matchups.count - 1 {
                        currentMatchupIndex += 1
                    }
                }
                .disabled(currentMatchupIndex == matchupManager.matchups.count - 1) // Disable button if on the last matchup
            }
            .padding()
            
            if let currentMatchup = matchupManager.matchups[safe: currentMatchupIndex] {
                MatchupRowView(matchup: currentMatchup)
            } else {
                Text("No matchup available") // Display a placeholder message if no matchup is available
            }
            
            Spacer()
        }.refreshable {
            await matchupManager.findLeagueMatchup(id: id, index: $currentMatchupIndex)
          }
        .task {
            await matchupManager.findLeagueMatchup(id: id, index: $currentMatchupIndex)

        }
    }
}

struct MatchupsView_Previews: PreviewProvider {
    static var previews: some View {
        let matchupManager = MatchupManager()
        let matchup = Matchup(id: 1, isActive: true, isFinalized: false, week: 1,
                              userOne: User(id: 1, fname: "User One", lname: "User Two"),
                              currentUserScore: 10,
                              userTwo: User(id: 2, fname: "Mike", lname: "Aronian"),
                              opponentScore: 50,
                              currentUser: 1)
        matchupManager.matchups = [matchup] // Assign a mock matchup to the matchups array
        
        return MatchupsView(id: 26, matchupManager: matchupManager) // Initialize MatchupsView with mock data
    }
}

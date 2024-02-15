//
//  MatchupRowView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/23/24.
//

import SwiftUI

struct MatchupRowView: View {
    var matchup: Matchup
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                ScoreView(title: matchup.opponentTitle(), score: matchup.opponentScoreRounded(), isFinalized: matchup.isFinalized, isUser: matchup.userOne.id == matchup.currentUser)
                Spacer()
                ScoreView(title: matchup.userTitle(), score: matchup.currentUserScoreRounded(), isFinalized: matchup.isFinalized, isUser: matchup.userTwo.id == matchup.currentUser)
            }
            .padding(10) // Reduced padding
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundGradient(matchup: matchup))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(matchup.isFinalized ? Color.gray : Color.white, lineWidth: 1) // Reduced stroke width
                    )
                    .shadow(color: .black, radius: 3, x: 0, y: 1) // Reduced shadow radius
            )
        }
    }

    private func backgroundGradient(matchup: Matchup) -> Color {
        if matchup.userTwoScore < matchup.userOneScore && matchup.isUser() {
            return ColorTheme.red.opacity(0.5)
        } else if matchup.userTwoScore > matchup.userOneScore && matchup.isUser() {
            return ColorTheme.green.opacity(0.5)
        } else {
            return Color.gray
        }
    }
}

struct ScoreView: View {
    var title: String
    var score: String
    var isFinalized: Bool
    var isUser:Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            HStack{
                if(isUser){
                    Image(systemName: "person")
                }
                Text(title)
                    .font(.custom("PixelFont", size: 14)) // Reduced font size
                    .foregroundColor(isFinalized ? Color.gray : .white)
            }
            Text("\(score)")
                .font(.custom("PixelFont", size: 14)) // Reduced font size
                .foregroundColor(isFinalized ? Color.gray : .white)
        }
    }
}

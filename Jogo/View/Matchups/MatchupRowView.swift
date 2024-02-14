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
        VStack {
            HStack {
                Text("Week: \(matchup.week)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.primary)
            }
            HStack {
                Text(matchup.opponentTitle())
                    .font(.custom("PixelFont", size: 20)) // Use a pixelated font
                    .foregroundColor(matchup.isFinalized ? Color.gray : .white) // Adjusted text color based on isFinalized
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Text("\(matchup.opponentScoreRounded())")
                    .font(.custom("PixelFont", size: 20)) // Use a pixelated font
                    .foregroundColor(matchup.isFinalized ? Color.gray : .white) // Adjusted text color based on isFinalized
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                
                Text("\(matchup.currentUserScoreRounded())")
                    .font(.custom("PixelFont", size: 20)) // Use a pixelated font
                    .foregroundColor(matchup.isFinalized ? Color.gray : .white) // Adjusted text color based on isFinalized
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundGradient(matchup: matchup))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(matchup.isFinalized ? Color.gray : Color.white, lineWidth: 2) // Adjusted stroke color based on isFinalized
                    )
                    .shadow(color: .black, radius: 5, x: 0, y: 2)
            )
        }
    }

    private func backgroundGradient(matchup: Matchup) -> LinearGradient {
        if matchup.opponentScoreRounded() > matchup.currentUserScoreRounded() {
            return LinearGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.8, blue: 0.8), Color(red: 0.8, green: 0.4, blue: 0.4)]), startPoint: .leading, endPoint: .trailing)
        } else if matchup.opponentScoreRounded() < matchup.currentUserScoreRounded() {
            return LinearGradient(gradient: Gradient(colors: [Color(red: 0.4, green: 0.8, blue: 0.4), Color(red: 0.4, green: 0.8, blue: 0.4)]), startPoint: .leading, endPoint: .trailing)
        } else {
            return LinearGradient(gradient: Gradient(colors: [ColorTheme.primary, ColorTheme.secondary]), startPoint: .leading, endPoint: .trailing)
        }
    }
}

//#Preview {
//    MatchupRowView()
//}

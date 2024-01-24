//
//  MatchupRowView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/23/24.
//

import SwiftUI

struct MatchupRowView: View {
    var matchup:Matchup
    var body: some View {
        HStack {
            Text(matchup.opponent)
                .font(.custom("PixelFont", size: 20)) // Use a pixelated font
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Text("\(matchup.opponentScore)")
                .font(.custom("PixelFont", size: 20)) // Use a pixelated font
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            
            Text("\(matchup.userScore)")
                .font(.custom("PixelFont", size: 20)) // Use a pixelated font
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        }
        .padding(16)
        .background(
            LinearGradient(gradient: Gradient(colors: [ColorTheme.primary, ColorTheme.secondary]), startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 2)
        )
        .shadow(color: .black, radius: 5, x: 0, y: 2)
    }
}

//#Preview {
//    MatchupRowView()
//}

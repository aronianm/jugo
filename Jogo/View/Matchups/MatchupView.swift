//
//  MatchupView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/23/24.
//

import SwiftUI

struct MatchupView: View {
    var matchup:Matchup
    var body: some View {
        VStack{
            HStack{
                VStack {
                    List {
                        ForEach(matchup.seasons ?? [], id: \.id) { season in
                            SeasonView(id: season.id)
                        }
                    }
                }
            }
            Spacer()
        }.background(ColorTheme.accent)
    }
}

#Preview {
    let userOne = User(id: 1, fname: "John", lname: "Doe")
    let userTwo = User(id: 2, fname: "Jane", lname: "Smith")

    let season = Season(id: 1, userOneWins: 2, userTwoWins: 1,  seasonMatchup: [SeasonMatchup(id: 2, week: 2, season_id: 1, userOneDailyScore: 15.2, userOneTotalScore: 120.0, userTwoDailyScore: 18.7, userTwoTotalScore: 130.0, userOneFormattedScore: 10.0, userTwoFormattedScore: 10.0)], matchup_id: 1)

    let matchup = Matchup(id: 1, isActive: true, isFinalized: false, week: 1, seasons: [season], userOne: userOne, currentUserScore: 10, userTwo: userTwo, opponentScore: 10, currentUser: userOne.id)
    return MatchupView(matchup: matchup)
}

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
            HStack(alignment: .center) {
                Spacer()
                Text(matchup.opponent())
                    .font(.title)
                    .foregroundColor(ColorTheme.white)
                    .padding()
                Spacer()
            }
            .background(ColorTheme.background)
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

    let season = Season(id: 1, userOneWins: 2, userTwoWins: 1, matchup_id: 1)

    let matchup = Matchup(id: 1, isActive: true, isFinalized: false, userAccepted: true, seasons: [season], userOne: userOne, userTwo: userTwo, currentUser: userOne.id)
    return MatchupView(matchup: matchup)
}

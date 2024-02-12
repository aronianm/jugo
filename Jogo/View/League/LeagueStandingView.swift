//
//  LeagueStandingView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

import SwiftUI

struct LeagueStandingsView: View {
    var userLeagues:[UserLeague]
    
    var body: some View {
        VStack {
            Text("Standings")
                .font(.title)
                .foregroundColor(ColorTheme.white)
                .padding()
            
            HStack {
                Text("User")
                Spacer()
                Text("Wins")
                Spacer()
                Text("Losses")
            }
            .padding(.horizontal)
            .font(.headline)
            
            Divider()
            
            ForEach(userLeagues) { userLeague in
                HStack {
                    Text(userLeague.user.formattedName())
                    Spacer()
                    Text("\(userLeague.wins)")
                    Spacer()
                    Text("\(userLeague.losses)")
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            Spacer()
        }
    }
}

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
            HStack {
                Text("User")
                    .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                Text("Wins")
                    .frame(maxWidth: .infinity, alignment: .center) // Align text to the center
                Text("Losses")
                    .frame(maxWidth: .infinity, alignment: .trailing) // Align text to the right
            }
            .padding(.horizontal)
            .font(.headline)
            
            Divider()
            
            ForEach(userLeagues) { userLeague in
                HStack {
                    Text(userLeague.user.formattedName())
                        .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                    Text("\(userLeague.wins)")
                        .frame(maxWidth: .infinity, alignment: .center) // Align text to the center
                    Text("\(userLeague.losses)")
                        .frame(maxWidth: .infinity, alignment: .trailing) // Align text to the right
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
}

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
                Text("User").foregroundColor(ColorTheme.white)
                Spacer()
                Text("Wins").foregroundColor(ColorTheme.white)
                Spacer()
                Text("Losses").foregroundColor(ColorTheme.white)
            }
            .padding(.horizontal)
            .font(.headline)
            
            Divider()
            
            ScrollView {
                ForEach(userLeagues) { userLeague in
                    HStack {
                        Text(userLeague.user.formattedName()).foregroundColor(ColorTheme.white)
                            .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                        Spacer()
                        Text("\(userLeague.wins)").foregroundColor(ColorTheme.white)
                            .frame(maxWidth: .infinity, alignment: .center) // Align text to the center
                        Spacer()
                        Text("\(userLeague.losses)").foregroundColor(ColorTheme.white)
                            .frame(maxWidth: .infinity, alignment: .trailing) // Align text to the right
                    }
                    .padding(.horizontal, 8) // Adjust horizontal padding
                    .padding(.vertical, 4) // Adjust vertical padding
                }
            }
        }.background(ColorTheme.background)
    }
}

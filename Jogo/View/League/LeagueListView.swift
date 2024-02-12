//
//  LeagueListView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

struct LeagueListView: View {
    @ObservedObject var leagueManager: LeagueManager
    
    var body: some View {
        NavigationView {
            List{
                ForEach(leagueManager.leagues) { league in
                    HStack {
                        Spacer()
                        LeagueRowView(league: league)
                            .padding(.vertical, 8)
                        Spacer()
                    }
                }

            }.listStyle(InsetGroupedListStyle()).background(ColorTheme.background)
            
        }.navigationTitle(Text("Fogo Leagues").foregroundColor(ColorTheme.white))
    }
}


struct LeagueRowView: View {
    var league: League
    
    var body: some View {
        NavigationLink(destination: LeagueView(league: league)) {
            VStack(alignment: .center) {
                Text(league.leagueName)
                    .font(.headline)
            }
            
        }
    }
}

#Preview {
    LeagueListView(leagueManager: LeagueManager())
}

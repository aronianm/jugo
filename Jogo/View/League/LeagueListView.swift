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
                        LeagueRowView(league: league, leagueManager: leagueManager)
                            .padding(.vertical, 8)
                        Spacer()
                    }
                }

            }.listStyle(InsetGroupedListStyle()).background(ColorTheme.background)
        }
    }
}


struct LeagueRowView: View {
    var league: League
    @ObservedObject var leagueManager: LeagueManager
    var body: some View {
        NavigationLink(destination: LeagueView(league: league, leagueManager: leagueManager)) {
            VStack(alignment: .center) {
                Text(league.leagueName)
                    .font(.headline)
            }
            
        }
    }
}

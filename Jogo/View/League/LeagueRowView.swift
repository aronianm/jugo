//
//  LeagueRowView.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 2/15/24.
//

import SwiftUI

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

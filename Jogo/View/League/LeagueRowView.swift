//
//  LeagueRowView.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 2/15/24.
//

import SwiftUI

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

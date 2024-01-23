//
//  MatchupsView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI

struct MatchupsView: View {
    var authViewModel: AuthenticationViewModel
    var matchups: [Matchup]
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Matchups").titleStyle().multilineTextAlignment(.center)
            NavigationLink(destination: ContactListView(authViewModel: authViewModel)) {
                Text("Find Opponent")
            }
            List(matchups, id: \.id) { matchup in
                
            }
            .padding(.horizontal, 16)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemBackground))
                .shadow(radius: 5)
        )
        .padding()
    }
}

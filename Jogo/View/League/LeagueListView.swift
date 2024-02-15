//
//  LeagueListView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

struct LeagueListView: View {
    @ObservedObject var leagueManager: LeagueManager
    @State private var isShowingAlert = false
    @State private var leagueIndexToDelete: Int?
    var body: some View {
        NavigationView {
            List {
                ForEach(leagueManager.leagues) { league in
                    HStack {
                        Spacer()
                        LeagueRowView(league: league, leagueManager: leagueManager)
                            .padding(.vertical, 8)
                        Spacer()
                    }
                }
                .onDelete { indexSet in
                    self.leagueIndexToDelete = indexSet.first
                    self.isShowingAlert = true
                }
            }
            .listStyle(InsetGroupedListStyle())
            .background(ColorTheme.background)
            .alert(isPresented: $isShowingAlert) {
                        Alert(
                            title: Text("Are you sure?"),
                            message: Text("You are about to leave this league. Are you sure?"),
                            primaryButton: .default(Text("Leave")) {
                                if let index = self.leagueIndexToDelete {
                                    let leagueIDToDelete = leagueManager.leagues[index].id
                                    leagueManager.deleteLeague(id: leagueIDToDelete)
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
        }
    }
}

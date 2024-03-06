//
//  LeagueView.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

struct LeagueView: View {
    var league: League
    @State private var showLeagueCode = false
    @State private var copiedCode = false
    @ObservedObject var matchupManager: MatchupManager

    init(league: League) {
        self.league = league
        self._matchupManager = ObservedObject(wrappedValue: MatchupManager(leagueId: league.id))
    }

    var body: some View {
        VStack {
            HStack {
                if league.userLeagues.count != league.numberOfUsersNeeded {
                    Button("Show League Code") {
                        showLeagueCode.toggle()
                    }
                    .padding()

                    if showLeagueCode {
                        Text(league.leagueCode!)
                            .onTapGesture {
                                UIPasteboard.general.string = league.leagueCode!
                                copiedCode = true
                            }
                            .padding()
                            .background(ColorTheme.background)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding()
                            .alert(isPresented: $copiedCode) {
                                Alert(title: Text("Code Copied"), message: Text("The league code has been copied to the clipboard."), dismissButton: .default(Text("OK")))
                            }
                    }
                }
            }
            VStack {
                LeagueStandingsView(userLeagues: league.userLeagues)
                MatchupsView(id: league.id, matchupManager: matchupManager)
                Spacer()
            }
        }
        .onAppear {
            getCurrentLeagueMatchup()
        }
    }

    func getCurrentLeagueMatchup() {
        guard let leagueId = matchupManager.leagueId else { return }
        matchupManager.refreshMatchups(id: leagueId)
    }
}

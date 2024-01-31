//
//  ChallengeListView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/23/24.
//

import SwiftUI

struct ChallengeListView: View {
    @StateObject var matchupManager:MatchupManager
    @State private var showRejectAlert = false
    @State private var showAcceptAlert = false
    var body: some View {
        List {
            ForEach(matchupManager.challengeInvitations, id: \.id) { matchup in
                HStack{
                    Text(matchup.opponent())
                    Spacer()
                    Button(action: {
                                    showAcceptAlert.toggle()
                                }) {
                                    Text("Accept")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(10)
                                }
                                .alert(isPresented: $showAcceptAlert) {
                                    Alert(
                                        title: Text("Accept Confirmation"),
                                        message: Text("Are you sure you want to accept this?"),
                                        primaryButton: .default(Text("Accept")) {
                                            matchupManager.updateMatch(id: matchup.id, params: ["userAccepted": true])
                                        },
                                        secondaryButton: .cancel {
                                            matchupManager.updateMatch(id: matchup.id, params: ["userAccepted": false])
                                            showAcceptAlert = false
                                        }
                                    )
                                }
                    Spacer()
                    Button(action: {
                                   showRejectAlert.toggle()
                               }) {
                                   Text("Reject")
                                       .foregroundColor(.white)
                                       .padding()
                                       .background(Color.red)
                                       .cornerRadius(10)
                               }
                               .alert(isPresented: $showRejectAlert) {
                                   Alert(
                                       title: Text("Reject Confirmation"),
                                       message: Text("Are you sure you want to reject this?"),
                                       primaryButton: .destructive(Text("Reject")) {
                                           // Handle reject action
                                           // You can perform additional actions here
                                       },
                                       secondaryButton: .cancel {
                                                   showRejectAlert = false
                                               }
                                   )
                               }
                }
            }
        }.onAppear{
            matchupManager.challengersInvites()
        }
    }
}

#Preview {
    ChallengeListView(matchupManager: MatchupManager())
}

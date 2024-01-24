//
//  MatchupsView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI

struct MatchupsView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    @StateObject var matchupManager:MatchupManager
    @State var showInactiveMessage:Bool = false
    var body: some View {
        VStack(spacing: 16) {
            Text("Matchups")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.primary) // Replace with your primary color
                .multilineTextAlignment(.center)
            
            NavigationLink(destination: ContactListView(authViewModel: authViewModel, matchupManager: matchupManager)) {
                Text("Find Opponent")
                    .font(.headline)
                    .foregroundColor(ColorTheme.primary)
                    .padding()
                    .background(ColorTheme.white) // Replace with your accent color
                    .cornerRadius(10)
            }
            HStack{
                
                Text(showInactiveMessage ? "User has not accepted your invitation yet" : "").foregroundColor(ColorTheme.background).background(ColorTheme.warning)
            }.padding(5)
            List {
                ForEach(matchupManager.matchups, id: \.id) { matchup in
                    if matchup.userAccepted == true{
                        NavigationLink(destination: MatchupView(id: matchup.id)){
                            MatchupRowView(matchup: matchup)
                        }
                    }else{
                        MatchupRowView(matchup: matchup).onTapGesture {
                            if(showInactiveMessage == false){
                                showInactiveMessage = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    showInactiveMessage = false
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.inset)
        }
    }
}


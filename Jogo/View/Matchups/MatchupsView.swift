//
//  MatchupsView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI

struct MatchupsView: View {
     @State private var shouldNavigateBack = false
     @StateObject var authViewModel: AuthenticationViewModel
     @StateObject var matchupManager: MatchupManager
     @State private var showInactiveMessage = false
     let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

     var body: some View {
         NavigationView {
             VStack {
                 Text("Matchups")
                     .font(.largeTitle)
                     .fontWeight(.bold)
                     .foregroundColor(ColorTheme.primary) // Replace with your primary color
                     .multilineTextAlignment(.center)
                 
                 NavigationLink(
                     destination: ContactListView(authViewModel: authViewModel, matchupManager: matchupManager, shouldNavigateBack: $shouldNavigateBack),
                     isActive: $shouldNavigateBack,
                     label: {
                         Text("Find Opponent")
                             .font(.headline)
                             .foregroundColor(ColorTheme.white)
                             .padding()
                             .background(ColorTheme.primary) // Replace with your accent color
                             .cornerRadius(10).onTapGesture {
                                 shouldNavigateBack = true
                             }
                     }
                 )
                 
                 
                 
                 HStack {
                     Text(showInactiveMessage ? "User has not accepted your invitation yet" : "")
                         .foregroundColor(ColorTheme.background)
                         .background(ColorTheme.warning)
                         .padding(5)
                 }
                 
                 List {
                     ForEach(matchupManager.matchups, id: \.id) { matchup in
                         if matchup.userAccepted == true {
                             NavigationLink(destination: MatchupView(id: matchup.id)) {
                                 MatchupRowView(matchup: matchup)
                             }
                         } else {
                             MatchupRowView(matchup: matchup)
                                 .onTapGesture {
                                     if !showInactiveMessage {
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
             .navigationBarBackButtonHidden(true)
         }
         .onReceive(timer) { _ in
             matchupManager.findAllMatchups()
         }
         .onAppear {
             matchupManager.findAllMatchups()
         }
         .onDisappear {
             // Invalidate the timer when the view disappears
             timer.upstream.connect().cancel()
         }
     }
 }

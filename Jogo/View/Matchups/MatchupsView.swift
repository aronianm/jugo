//
//  MatchupsView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI

struct MatchupsView: View {
    var id: Int
    @StateObject var matchupManager: MatchupManager
    @State private var currentMatchupIndex: Int = 1
    @State var loading:Bool = true

    var body: some View {
        VStack { // Set alignment to leading
            Text("Matchups")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.blue) // Replace with your primary color
            if(loading == false ){
                HStack{
                    Text("Week: \(currentMatchupIndex)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.primary)
                    Spacer()
                    Text("Swipe to view next week").font(.caption)
                }
                ScrollView {
                    ForEach(matchupManager.matchups.filter { $0.week == currentMatchupIndex }) { currentMatchup in
                        MatchupRowView(matchup: currentMatchup).background(ColorTheme.background)
                    }.padding(20)
                }.background(ColorTheme.background).gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 100 { // Swipe right
                                if currentMatchupIndex > 1 {
                                    currentMatchupIndex -= 1
                                }
                            } else if value.translation.width < -100 { // Swipe left
                                if matchupManager.matchups.filter { $0.week == currentMatchupIndex + 1 }.isEmpty == false {
                                    currentMatchupIndex += 1
                                }
                            }
                        }
                )
               
            }
        }.padding(5).border(Color.black, width: 1).refreshable {
            await matchupManager.findLeagueMatchup(id: id, index: $currentMatchupIndex)
          }
        .task {
            await matchupManager.findLeagueMatchup(id: id, index: $currentMatchupIndex)
            loading = false

        }
    }
}

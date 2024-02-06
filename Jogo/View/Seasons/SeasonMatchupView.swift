//
//  SeasonMatchupView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/5/24.
//

import SwiftUI

struct SeasonMatchupView: View {
    var seasonMatchup: SeasonMatchup
    var matchup:Matchup

    var body: some View {
        let userOneTotalScore = matchup.userOne.id != matchup.user().id ? seasonMatchup.userOneFormattedScore : seasonMatchup.userTwoFormattedScore
        let userTwoTotalScore = matchup.userOne.id == matchup.user().id ? seasonMatchup.userOneFormattedScore : seasonMatchup.userTwoFormattedScore
        
        let userOneBackgroundColor: Color = {
            if userOneTotalScore > userTwoTotalScore {
                return ColorTheme.green
            } else if userOneTotalScore < userTwoTotalScore {
                return ColorTheme.secondary
            } else {
                return Color.gray.opacity(0.6)
            }
        }()
        
        let userTwoBackgroundColor: Color = {
            if userOneTotalScore > userTwoTotalScore {
                return ColorTheme.secondary
            } else if userOneTotalScore < userTwoTotalScore {
                return ColorTheme.green
            } else {
                return Color.gray.opacity(0.6)
            }
        }()
        
        return VStack(alignment: .leading, spacing: 10) {
            Text("Week \(seasonMatchup.week)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            HStack {
                VStack(alignment: .leading) {
                    Spacer()
                    Text("User One")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Total Score: \(userOneTotalScore)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(userOneBackgroundColor)
                .cornerRadius(15)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Spacer()
                    Text("User Two")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Total Score: \(userTwoTotalScore)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(userTwoBackgroundColor)
                .cornerRadius(15)
               
            }
            // Apply corner radius to the HStack
            
        }
        .padding()
        .background(ColorTheme.primary)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}



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
    
    @State private var isShowingInputPopup = false
    @State private var inputValue = ""
    
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
            HStack{
                Text("Week \(seasonMatchup.week)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                if seasonMatchup.startMatchup == false {
                    Button(action: {
                        isShowingInputPopup = true
                    }) {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .sheet(isPresented: $isShowingInputPopup) {
                        VStack {
                            Text("Enter Week Goal")
                                .foregroundColor(.black)
                                .padding()
                            TextField("Enter goal", text: $inputValue)
                                .padding()
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            Button(action: {
                                // Send post request to API with inputValue
                                // Close the popup
                                isShowingInputPopup = false
                            }) {
                                Text("Submit")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                }
            }
            if(seasonMatchup.startMatchup == false){
                Text("This matchup has not started yet")
            }
            SeasonMatchupCardsView(userOneTotalScore: userOneTotalScore, userOneBackgroundColor: userOneBackgroundColor, userTwoTotalScore: userTwoTotalScore, userTwoBackgroundColor: userTwoBackgroundColor)
            // Apply corner radius to the HStack
            
        }
        .padding()
        .background(ColorTheme.primary)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}



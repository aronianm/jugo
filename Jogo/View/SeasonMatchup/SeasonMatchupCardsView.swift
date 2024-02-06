//
//  SeasonMatchupCardsView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/5/24.
//

import SwiftUI

struct SeasonMatchupCardsView: View {
    var userOneTotalScore:Float
    var userOneBackgroundColor:Color
    var userTwoTotalScore:Float
    var userTwoBackgroundColor:Color
    var body: some View {
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
    }
}

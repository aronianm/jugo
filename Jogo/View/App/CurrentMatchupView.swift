//
//  CurrentMatchupView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct CurrentMatchupView: View {
    @StateObject private var healthDataManager = HealthDataManager()
    var body: some View {
        VStack{
            HStack{
                Text("Current Matchup").font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.blue.opacity(0.2))
                    )
                    .padding(.horizontal)
            }
            HStack {
                Text("Energy: \(healthDataManager.formattedValue(value: healthDataManager.activeEnergy))")
                Text("Exercise: \(healthDataManager.formattedValue(value: healthDataManager.exerciseMinutes))")
                Text("Stand: \(healthDataManager.formattedValue(value: healthDataManager.standHours))")
            }
            HStack{
                Text("Matchup").font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.blue.opacity(0.2))
                    )
                    .padding(.horizontal)
            }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack(alignment: .center) {
                HStack {
                    VStack(alignment: .center){
                        Text("Energy")
                    }
                    CircularProgressView(progress: 0.2, color: Color.red)
                }
                HStack{
                    VStack{
                        Text("Exercise")
                    }
                    CircularProgressView(progress: 0.3, color: Color.green)
                }
                HStack{
                    VStack{
                        Text("Standing")
                    }
                    CircularProgressView(progress: 0.8, color: Color.blue)
                }
            }
            Spacer()
                
        }
    }
}

#Preview {
    CurrentMatchupView()
}

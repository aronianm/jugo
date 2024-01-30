//
//  HistoryView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI

struct HistoryView: View {
    @StateObject var matchupManager:MatchupManager
    @StateObject var healthManager = HealthDataManager()
    @State var userWins = 0
    @State var userLosses = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Your History")
                .font(.custom("PixelFont", size: 20))  // Replace "Your80sFont"
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.accent) // Use bold and vibrant colors
                
            HStack(spacing: 16) {
                // Health Data
                VStack(alignment: .leading, spacing: 8) {
                    HealthDataRow(title: "Active", value: healthManager.formattedValue(value: healthManager.activeEnergy))
                        .foregroundColor(ColorTheme.primary)
                    HealthDataRow(title: "Exercise", value: healthManager.formattedValue(value: healthManager.exerciseMinutes))
                        .foregroundColor(ColorTheme.primary)
                    HealthDataRow(title: "Stand", value: healthManager.formattedValue(value: healthManager.standHours))
                        .foregroundColor(ColorTheme.primary)
                }
                
                Spacer()
                
                // User Stats
                VStack(alignment: .leading, spacing: 8) {
                    UserStatRow(title: "Wins", value: "\(userWins)")
                        .foregroundColor(ColorTheme.secondary)
                    UserStatRow(title: "Losses", value: "\(userLosses)")
                        .foregroundColor(ColorTheme.secondary)
                }
            }.onAppear {
                matchupManager.updateScores(healthManager: healthManager)
            }
        }
        .padding(16)
        .background(
            LinearGradient(gradient: Gradient(colors: [ColorTheme.accent, ColorTheme.accent]), startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.primary, lineWidth: 2)
        )
        .shadow(color: .black, radius: 5, x: 0, y: 2)
    }
}

struct HealthDataRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.white) // Use your primary brand color
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundColor(ColorTheme.white) // Use your secondary brand color
        }
    }
}

struct UserStatRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.white) // Use your primary brand color
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundColor(ColorTheme.white) // Use your secondary
        }
    }
}

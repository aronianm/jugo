//
//  HistoryView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI

struct UserStats {
    let username: String
    let wins: Int
    let losses: Int
}


struct HistoryView: View {
    @StateObject var matchupManager:MatchupManager
    @StateObject var healthManager = HealthDataManager()
    @State var userWins = 0
    @State var userLosses = 0
    
    let userStats: [UserStats] = [
            UserStats(username: "User1", wins: 5, losses: 3),
            UserStats(username: "User2", wins: 7, losses: 1),
            UserStats(username: "User3", wins: 4, losses: 2)
        ]
    var body: some View {
        VStack(spacing: 16) {
            Text("Your History")
                .font(.custom("PixelFont", size: 20))  // Replace "Your80sFont"
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.accent) // Use bold and vibrant colors
                
            HStack(spacing: 16) {
                // Health Data
                VStack(alignment: .center, spacing: 8) {
                    ProgressBar(title: "Active", progress: calculateProgress(healthManager.activeEnergy, goal: healthManager.moveGoal), color: Color.blue)
                    ProgressBar(title: "Exercise", progress: calculateProgress(healthManager.exerciseMinutes, goal: healthManager.exerciseGoal), color: Color.green)
                    ProgressBar(title: "Stand", progress: calculateProgress(healthManager.standHours, goal: healthManager.standGoal), color: Color.orange)

                }
                
                Spacer()
                
                // User Stats
                VStack(spacing: 16) {
                    Text("League Standings")
                        .font(.custom("PixelFont", size: 20))  // Replace "Your80sFont"
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.accent) // Use bold and vibrant colors
                    
                    ForEach(userStats, id: \.username) { user in
                        HStack(spacing: 16) {
                            Text(user.username)
                                .foregroundColor(ColorTheme.primary)
                            Spacer()
                            VStack(alignment: .leading, spacing: 8) {
                                UserStatRow(title: "Wins", value: "\(user.wins)")
                                    .foregroundColor(ColorTheme.secondary)
                                UserStatRow(title: "Losses", value: "\(user.losses)")
                                    .foregroundColor(ColorTheme.secondary)
                            }
                        }
                    }
                    
                    // Optional: Include health data if needed
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
    
    func calculateProgress(_ value: Double, goal: Double) -> Double {
        guard goal != 0 else {
            // Handle the case where the goal is zero (or not available)
            return 0 // Return a default value, such as zero
        }

        return value / goal
    }
}


struct ProgressBar: View {
    var title: String
    var progress: Double
    var color: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(ColorTheme.white)
            ZStack {
                Circle()
                    .stroke(lineWidth: 10.0)
                    .opacity(0.3)
                    .foregroundColor(color)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear)
                
            }
            .padding()
        }
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

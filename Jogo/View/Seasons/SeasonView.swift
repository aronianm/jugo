//
//  SeasonView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/30/24.
//

import SwiftUI

struct SeasonView: View {
    var id: Int
    @State private var season: Season?
    @State private var isLoading = false


    var body: some View {
        Group {
            if let season = season {
                VStack{
                    // Display season stats
                    HStack {
                        SeasonStatsView(title: season.matchup?.opponentTitle() ?? "Opponent", value: "\(season.userOneWins)")
                        Spacer()
                        SeasonStatsView(title: season.matchup?.userTitle() ?? "User", value: "\(season.userOneWins)")
                    }
                    .padding(10)
                    .background(Color.secondary)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary, lineWidth: 2)
                    )
                    Spacer()
                    if let seasonMatchups = season.seasonMatchup {
                        ForEach(seasonMatchups, id: \.self) { seasonMatchup in
                            SeasonMatchupView(seasonMatchup: seasonMatchup, matchup: season.matchup!)
                        }
                    }
                }
            } else {
                // Show loading indicator or error message
                Text("Loading...")
            }
        }
        .onAppear {
            loadData()
        }
    }

    private func loadData() {
        let baseURL = Environment.apiBaseURL
        let authToken:String =  UserDefaults.standard.string(forKey: "AuthToken") ?? ""
        // Make a GET request to fetch season data
        guard let url = URL(string: "\(baseURL)/seasons/\(id)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")


        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoder = JSONDecoder()
                let season = try decoder.decode(Season.self, from: data)
                DispatchQueue.main.async {
                    self.season = season
                    isLoading = false
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct SeasonStatsView: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(ColorTheme.primary)
            
            Text(value)
                .font(.title)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    SeasonView(id: 1)
}

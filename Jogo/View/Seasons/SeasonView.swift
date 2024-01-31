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
                // Display season stats
                HStack {
                    SeasonStatsView(title: "User One Wins", value: "\(season.userOneWins)")
                    Spacer()
                    SeasonStatsView(title: "User Two Wins", value: "\(season.userTwoWins)")
                }
                .padding(10)
                .background(Color.primary)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 2)
                )
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
        guard !isLoading else { return }
        isLoading = true

//        // Make a GET request to fetch season data
//        let url = URL(string: "your_api_url/\(id)")!
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {
//                print("No data received: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let season = try decoder.decode(Season.self, from: data)
//                DispatchQueue.main.async {
//                    self.season = season
//                    isLoading = false
//                }
//            } catch {
//                print("Error decoding data: \(error.localizedDescription)")
//            }
//        }.resume()
    }
}

struct SeasonStatsView: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(ColorTheme.secondary)
            
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

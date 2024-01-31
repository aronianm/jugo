//
//  MatchupView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/23/24.
//

import SwiftUI

struct MatchupView: View {
    var id:Int
    @State var matchup:Matchup?
    var authToken:String =  UserDefaults.standard.string(forKey: "AuthToken") ?? ""
    let baseURL = Environment.apiBaseURL
    var body: some View {
        VStack{
            if(matchup != nil){
                VStack {
                            Text(matchup?.opponent() ?? "")
                                .font(.title)
                                .foregroundColor(ColorTheme.white)
                                .padding()

                            HStack {
                                CircularProgressView(progress: 0.2, color: ColorTheme.green)
                                CircularProgressView(progress: 0.6, color: ColorTheme.red)
                                CircularProgressView(progress: 0.9, color: ColorTheme.barBlue)
                            }

                            Spacer()
                        }
                        .background(ColorTheme.background)
                        .cornerRadius(16)
            }
        }.onAppear {
        // Replace with your API endpoint URL
                guard let url = URL(string: "\(baseURL)/matchups/\(id)") else {
                    print("Invalid URL")
                    return
                }
            
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")


                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }

                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            // Assuming your API returns an array of Matchup objects
                            let decodedMatchups = try decoder.decode(Matchup.self, from: data)
                            DispatchQueue.main.async {
                                matchup = decodedMatchups
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }.resume()
        }
    }
}

#Preview {
    MatchupView(id: 6)
}

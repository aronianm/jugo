//
//  MatchupManager.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import Foundation

import SwiftUI


class MatchupManager: ObservableObject {
    @Published var matchups: [Matchup] = []
    @Published var activeMatchups: [Matchup] = []
    @Published var activeMatch:Matchup?
    var userToken:String = ""
    let baseURL = Environment.apiBaseURL


    // Additional functions for managing matchups can be added here
    func findAllMatchups(completion: @escaping (Result<[Matchup], Error>) -> Void) {
            guard let url = URL(string: "\(baseURL)/matchups") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
        
        
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(userToken)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.success([]))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let decodedMatchups = try decoder.decode([Matchup].self, from: data)
                    self.matchups = decodedMatchups
                    completion(.success(decodedMatchups))
                } catch {
                    print("Error \(error)")
                    completion(.failure(error))
                }
            }.resume()
        }
}

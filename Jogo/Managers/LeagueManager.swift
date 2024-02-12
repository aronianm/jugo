//
//  LeagueManager.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import Foundation


class LeagueManager: ObservableObject {
    
    @Published var league:League?
    @Published var leagues:[League] = []
    
    let baseURL = Environment.apiBaseURL
    var authToken:String =  UserDefaults.standard.string(forKey: "AuthToken") ?? ""
    var userId =  UserDefaults.standard.string(forKey: "userId") ?? ""
    
    
    func getLeagues() {
        guard let url = URL(string: "\(baseURL)/leagues/") else {
            return
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                return
            }

            guard let data = data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedMatchup = try decoder.decode([League].self, from: data)
                self.leagues = decodedMatchup
            } catch {
                print("Error \(error)")
            }
        }.resume()
    }
    func findLeague(completion: @escaping (Result<League, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/leagues/\(userId)/users") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedMatchup = try decoder.decode(League.self, from: data)
                self.league = decodedMatchup
                completion(.success(decodedMatchup))
            } catch {
                print("Error \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func createLeague(leagueName: String, numberOfWeeks: Int, completion: @escaping (Result<Void, Error>) -> Void) {
            let parameters: [String: Any] = ["league":[
                "leagueName": leagueName,
                "numberOfWeeks": numberOfWeeks
            ]]
        
            guard let url = URL(string: "\(baseURL)/leagues/") else {
                return
            }

            var request = URLRequest(url: url)
        
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
            } catch {
                print("Error encoding JSON: \(error)")
                return
            }
        
            

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                // Handle response data here
                // For example, you can decode the response JSON data
                // to extract any relevant information
                do {
                    let responseJson = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Response: \(responseJson)")
                    // You can perform additional handling of the response data here
                } catch {
                    print("Error decoding response JSON: \(error)")
                }
            }.resume()
    }
    
}

//
//  LeagueManager.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import Foundation


class LeagueManager: ObservableObject {
    
    @Published var league:League?
    @Published var leagues:[League] = []
    
    let baseURL = Environment.apiBaseURL
    
    
    func getLeagues() {
        guard let url = URL(string: "\(baseURL)/leagues/") else {
            return
        }

        if let authToken = UserDefaults.standard.string(forKey: "jwt") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                print("Running")
                
//                if let error = error {
//                    return
//                }
                
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
    }
    func findLeague(completion: @escaping (Result<League, Error>) -> Void) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            return
        }
                
        if let authToken = UserDefaults.standard.string(forKey: "jwt") {
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
    }
    
    func deleteLeague(id: Int) {
        
        // Make delete request to server
        if let authToken = UserDefaults.standard.string(forKey: "jwt") {
            let url = URL(string: "\(baseURL)/leagues/\(id)/leave_league")!
            var request = URLRequest(url: url)
            request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error deleting league: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    // Ensure leagues array is not empty and leagues are properly populated
                    guard !self.leagues.isEmpty else {
                        print("Leagues array is empty")
                        return
                    }
                    
                    // Find the index of the league with ID equal to 1
                    if let index = self.leagues.firstIndex(where: { $0.id == id }) {
                        // Remove the league at the found index
                        self.leagues.remove(at: index)
                        print("League at index \(index) deleted")
                        
                        // Call getLeagues to update leagues array
                        self.getLeagues()
                    } else {
                        // ID not found
                        print("ID 1 not found in leagues array")
                    }
                }
            }.resume()
        }
    }
    
    func createLeague(leagueName: String, numberOfWeeks: Int, numberOfUsers: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: Any] = ["league":[
            "leagueName": leagueName,
            "numberOfWeeks": numberOfWeeks,
            "numberOfUsersNeeded": numberOfUsers
        ]]
        if let authToken = UserDefaults.standard.string(forKey: "jwt") {
            guard let url = URL(string: "\(baseURL)/leagues/") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
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
                completion(.failure(error))
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
//                guard let data = data else {
//                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
//                    return
//                }
                
                self.getLeagues()
                completion(.success(()))
            }.resume()
        }else{
            print("No where to go")
        }
    }
    
    func joinLeague(code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let authToken = UserDefaults.standard.string(forKey: "jwt") else {
            completion(.failure(NSError(domain: "Auth token not found", code: 0, userInfo: nil)))
            return
        }

        let parameters: [String: Any] = ["league": ["code": code]]

        guard let url = URL(string: "\(baseURL)/leagues/join") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
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
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }

            // Assuming success if HTTP status code is in the success range
            // You can handle other cases (e.g., error response from server) accordingly

            // Now, you would send push notifications to users in the league from your backend server

            completion(.success(()))
        }.resume()
    }
    
}

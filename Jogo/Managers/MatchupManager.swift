//
//  MatchupManager.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import Foundation
import SwiftUI
import Contacts
import HealthKit

class MatchupManager: ObservableObject {
    @Published var matchups: [Matchup] = []
    @Published var activeMatchups: [Matchup] = []
    @Published var challengeInvitations: [Matchup] = []
    @Published var activeMatch:Matchup?
    @Published var isChallengeSent:Bool = false
    @Published var activeIndex:Int = 0

    @State var activeUser:Int?
    
    
    let healthManager = HealthDataManager()
    var authToken:String =  UserDefaults.standard.string(forKey: "AuthToken") ?? ""
    var userExists:Bool = false
    let baseURL = Environment.apiBaseURL
    
    func updateAllScores(id:Int, index:Binding<Int>) {
        let activeEnergy = healthManager.activeEnergy
        let standHours = healthManager.standHours
        let exerciseMinutes = healthManager.exerciseMinutes

        let sum = activeEnergy + standHours + exerciseMinutes

        for (i, matchup) in self.matchups.enumerated() {
            if(matchup.isActive){
                index.wrappedValue = i
                guard let url = URL(string: "\(baseURL)/leagues/\(id)/matchups/\(matchup.id)/update_scores") else {
                    // Handle the case where the URL is invalid
                    continue
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let parameters: [String: Any] = [
                    "score": sum
                ]
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                    request.httpBody = jsonData
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            // Handle the error from the data task
                            print("Error updating scores: \(error)")
                            return
                        }
                        
                        guard let data = data else {
                            // Handle the case where no data is returned
                            return
                        }
                        
                        DispatchQueue.main.async {
                            do {
                                let decoder = JSONDecoder()
                                let decodedMatchup = try decoder.decode(Matchup.self, from: data)
                                
                                // Update the existing matchup in self.matchups with the new data
                                if let index = self.matchups.firstIndex(where: { $0.id == decodedMatchup.id }) {
                                    self.matchups[index] = decodedMatchup
                                    self.activeIndex = index
                                }
                            } catch {
                                // Handle the error if decoding fails
                                print("Error decoding response: \(error)")
                            }
                        }
                    }.resume()
                } catch {
                    // Handle the error if JSON serialization fails
                    print("Error serializing JSON: \(error)")
                }
            }
        }
    }
    func sendChallengeRequest(completion: @escaping (Result<Matchup, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/matchups") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
    
        let parameters = ["matchup": ["user1": activeUser]]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        } catch {
            // Handle the error if JSON serialization fails
            print("Error serializing JSON: \(error)")
        }

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
                let decodedMatchup = try decoder.decode(Matchup.self, from: data)
                self.activeMatch = decodedMatchup
                completion(.success(decodedMatchup))
            } catch {
                print("Error \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func updateMatch(id: Int, params: [String: Any]) {
        guard let url = URL(string: "\(baseURL)/matchups/\(id)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
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
    func deleteMatchup(id:Int){
        guard let url = URL(string: "\(baseURL)/matchups/\(id)") else {
            return
        }
    
    
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                return
            }

            guard let data = data else {
                return
            }

            do {
                print("Succesfully deletion")
            } catch {
                print("Error \(error)")
            }
        }.resume()
    }
    // Additional functions for managing matchups can be added here
    func findLeagueMatchup(id: Int, index: Binding<Int>) async {
            guard let url = URL(string: "\(baseURL)/leagues/\(id)/matchups") else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    return
                }

                guard let data = data else {
                    return
                }
                print("Decoding")
                do {
                    let decoder = JSONDecoder()
                   
                    let decodedMatchups = try decoder.decode([Matchup].self, from: data)
                    self.matchups = decodedMatchups
                    self.updateAllScores(id: id, index: index)
                } catch {
                    print("Error \(error)")
                }
            }.resume()
    }
    func findMobileNumber(in phoneNumbers: [CNLabeledValue<CNPhoneNumber>]) -> String? {
        for phoneNumber in phoneNumbers {
            let label = phoneNumber.label ?? ""
            let number = phoneNumber.value.stringValue
            
            if label.lowercased().contains("mobile") {
                return number
            }
            
            // You can customize the conditions based on the label if needed
            // For example, you might check for labels like "iPhone" or "Mobile"
        }
        
        return nil
    }
    
    func challengersInvites() {
        guard let url = URL(string: "\(baseURL)/matchups/challenges") else {
            return
        }
    
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                return
            }

            guard let data = data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedMatchups = try decoder.decode([Matchup].self, from: data)
                self.challengeInvitations = decodedMatchups
            } catch {
                print("Error \(error)")
            }
        }.resume()
    }
    func checkIfUser(for contact: CNContact) {
        self.userExists = false
        self.activeUser =  nil
        guard let url = URL(string: "\(baseURL)/users/check_user") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        
        let mobileNumber = findMobileNumber(in: contact.phoneNumbers)
        
        let payload = [
            "phone_number": mobileNumber ?? "",
            "name": contact.givenName
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Ensure that UI-related tasks are performed on the main thread
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    // Handle error scenarios
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    // Handle unexpected response scenarios
                    return
                }
                
                print("Status Code: \(httpResponse.statusCode)")
                
                if let data = data {
                    // Parse and handle the response data
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonResponse = jsonResponse as? [String: Any] {
                            // Now jsonResponse is safely cast as a dictionary

                            if let userFound = jsonResponse["user_found"] as? Int {
                                // Use userFound here
                                self.userExists = userFound == 1
                            } else {
                                // Handle the case where "user_found" is not an integer
                                print("Error: 'user_found' is not an integer")
                            }
                            
                            if let userId = jsonResponse["user_id"] as? Int {
                                self.activeUser = userId
                            } else{
                                // Handle the case where "user_found" is not an integer
                                print("Error: 'user_id' is not an integer")
                            }
                        } else {
                            // Handle the case where jsonResponse is not a dictionary
                            print("Error: jsonResponse is not a dictionary")
                        }
                        // Handle the response data
                    } catch {
                        print("Error decoding response: \(error)")
                        // Handle decoding error scenarios
                    }
                }
            }
        }.resume()
    }
}

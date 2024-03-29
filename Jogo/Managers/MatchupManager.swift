//
//  MatchupManager.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import Foundation
import SwiftUI
import Contacts
import HealthKit
import Combine

class MatchupManager: ObservableObject {
    @Published var matchups: [Matchup] = []
    @Published var activeMatchups: [Matchup] = []
    @Published var challengeInvitations: [Matchup] = []
    @Published var activeMatch:Matchup?
    @Published var isChallengeSent:Bool = false
    @Published var activeIndex:Int = 0

    @State var activeUser:Int?
    @State var leagueId:Int?
    @State var bindingIndex = 0
    
    let healthManager = HealthDataManager()
    var userExists:Bool = false
    let baseURL = Environment.apiBaseURL
    
    private var cancellables: Set<AnyCancellable>? // Make it optional

    init(leagueId: Int) {
        self.leagueId = leagueId
        findLeagueMatchup(leagueId: leagueId)
    }

    
    func updateAllScores(index:Binding<Int>) {
        let activeEnergy = healthManager.activeEnergy
        let standHours = healthManager.standHours
        let exerciseMinutes = healthManager.exerciseMinutes

        let sum = activeEnergy + standHours + exerciseMinutes

        for (_, matchup) in self.matchups.enumerated() {
            if(matchup.isActive){
                index.wrappedValue = matchup.week
                guard let url = URL(string: "\(baseURL)/leagues/\(self.leagueId!)/matchups/\(matchup.id)/update_scores") else {
                    // Handle the case where the URL is invalid
                    continue
                }
                let authToken:String =  UserDefaults.standard.string(forKey: "jwt") ?? ""
                
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

    func updateMatch(id:Int, params: [String: Any]) {
        guard let url = URL(string: "\(baseURL)/matchups/\(id)") else {
            return
        }
        let authToken:String =  UserDefaults.standard.string(forKey: "jwt") ?? ""
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
        let authToken:String =  UserDefaults.standard.string(forKey: "jwt") ?? ""
    
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                return
            }

           if data == nil {
                return
            }

            print("Succesfully deletion")
            
        }.resume()
    }
    func refreshMatchups(id: Int){
        guard let url = URL(string: "\(baseURL)/leagues/\(id)/matchups") else {
            return
        }
        let authToken:String =  UserDefaults.standard.string(forKey: "jwt") ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if(error != nil){
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
                let activeEnergy = self.healthManager.activeEnergy
                let standHours = self.healthManager.standHours
                let exerciseMinutes = self.healthManager.exerciseMinutes

                let sum = activeEnergy + standHours + exerciseMinutes

                for (_, matchup) in self.matchups.enumerated() {
                    if(matchup.isActive){
                        guard let url = URL(string: "\(self.baseURL)/leagues/\(id)/matchups/\(matchup.id)/update_scores") else {
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
            } catch {
                print("Error \(error)")
            }
        }.resume()
    }
    
    func findLeagueMatchup(leagueId: Int) {
        guard let url = URL(string: "\(baseURL)/leagues/\(leagueId)/matchups") else {
            return
        }
        let authToken = UserDefaults.standard.string(forKey: "jwt") ?? ""
        
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
                let decodedMatchup = try decoder.decode([Matchup].self, from: data)
                self.matchups = decodedMatchup
                
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
    
        let authToken:String =  UserDefaults.standard.string(forKey: "jwt") ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if(error != nil){
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
}

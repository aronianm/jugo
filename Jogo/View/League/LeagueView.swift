//
//  LeagueView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

struct LeagueView: View {
    var league:League
    var leagueManager:LeagueManager
    @State var matchup:Matchup?
    @State private var showLeagueCode = false
    
    var body: some View {
        VStack {
            HStack {
                if(league.userLeagues.count != league.numberOfUsersNeeded){
                   
                    Button("Show League Code") {
                        showLeagueCode.toggle() // Toggle the state variable
                    }
                    .padding()
                    
                    if showLeagueCode  {
                        Text(league.leagueCode!).onTapGesture {
                            UIPasteboard.general.string = league.leagueCode!
                        }
                    }
                }
            }
            VStack{
                LeagueStandingsView(userLeagues: league.userLeagues)
                MatchupsView(id: league.id, matchupManager: leagueManager.matchupManager)
            }
        }
    }
    
    func getCurrentLeagueMatchup() {
        let baseURL = Environment.apiBaseURL
        let authToken:String =  UserDefaults.standard.string(forKey: "AuthToken") ?? ""
      
        let url = URL(string: "\(baseURL)/leagues/\(league.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check if data is available
            guard let data = data else {
                return
            }
            
            do {
                // Map the JSON data to Matchup struct
                matchup = try JSONDecoder().decode(Matchup.self, from: data)
            } catch {
                
            }
        }.resume() // Start the data task
    }
}


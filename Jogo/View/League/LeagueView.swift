//
//  LeagueView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

struct LeagueView: View {
    var league:League
    @State var matchup:Matchup?
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(league.leagueName).font(.title) 
                Spacer()
            }
            .padding()
            VStack{
                if(matchup != nil){
                    MatchupRowView(matchup: matchup!)
                }
            }
            VStack{
                LeagueStandingsView(userLeagues: league.userLeagues)
                
            }
            
            Spacer()
        }.onAppear {
            getCurrentLeagueMatchup()
        }
    }
    
    func getCurrentLeagueMatchup() {
        let baseURL = Environment.apiBaseURL
        let authToken:String =  UserDefaults.standard.string(forKey: "AuthToken") ?? ""
        let userId =  UserDefaults.standard.string(forKey: "userId") ?? ""
      
        let url = URL(string: "\(baseURL)/leagues/\(league.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                return
            }
            
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


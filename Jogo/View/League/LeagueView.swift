//
//  LeagueView.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

struct LeagueView: View {
    var league: League
    @State private var matchup: Matchup?
    @StateObject var matchupManager: MatchupManager
    @State private var showLeagueCode = false
    @State private var copiedCode = false
    
    init(league: League) {
        self.league = league
        self._matchupManager = StateObject(wrappedValue: MatchupManager(leagueId: league.id))
    }
    
    var body: some View {
        VStack {
            HStack {
                if (league.userLeagues.count != league.numberOfUsersNeeded) {
                    
                    Button("Show League Code") {
                        showLeagueCode.toggle() // Toggle the state variable
                    }
                    .padding()
                    
                    if showLeagueCode {
                        Text(league.leagueCode!)
                            .onTapGesture {
                                UIPasteboard.general.string = league.leagueCode!
                                copiedCode = true // Set copiedCode to true when the code is copied
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    copiedCode = false // Reset copiedCode after 2 seconds
                                }
                            }
                            .padding()
                            .background(ColorTheme.background)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding()
                            .alert(isPresented: $copiedCode) {
                                Alert(title: Text("Code Copied"), message: Text("The league code has been copied to the clipboard."), dismissButton: .default(Text("OK")))
                            }
                    }
                }
            }
            VStack{
                LeagueStandingsView(userLeagues: league.userLeagues)
                MatchupsView(id: league.id, matchupManager: matchupManager)
                Spacer()
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


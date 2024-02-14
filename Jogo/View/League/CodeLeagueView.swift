//
//  CodeLeagueView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

struct CodeLeagueView: View {
    var leagueManager:LeagueManager
    @State var code:String = ""
    @Binding var showCode:Bool
    var body: some View {
        VStack {
            Text("Code for your league")
                .font(.title)
                .foregroundColor(.white) // Adjust text color
                .padding(.top, 20) // Add top padding
            
            TextField("Code", text: $code)
                .padding()
                .background(ColorTheme.secondary) // Set background color to match the theme
                .cornerRadius(10) // Apply corner radius
                .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2) // Add shadow for depth
                .padding([.horizontal, .bottom], 20) // Add horizontal and bottom padding
            
            Spacer()
            Button(action: joinLeague) {
                Text("Join League")
                    .foregroundColor(.white)
                    .padding()
                    .background(ColorTheme.accent)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .background(ColorTheme.accent.opacity(0.9)) // Use a light gray background
        .cornerRadius(20) // Apply corner radius to VStack
        .padding(20) // Add padding to VStack
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    
    func joinLeague() {
       
        
//        // Assuming you have a function to make the API POST request
        leagueManager.joinLeague(code: code) { result in
            switch result {
            case .success:
                leagueManager.getLeagues()
                showCode = false
            case .failure(let error):
                print("Failed to create league: \(error)")
            }
        }
    }
}

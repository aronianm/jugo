//
//  CreateLeagueView.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

struct CreateLeagueView: View {
    @State private var leagueName = ""
    @State private var numberOfWeeks = ""
    @State private var numberOfUsers = ""
    @State private var isLoading = false
    @State private var showAlert = false
    
    var leagueManager:LeagueManager
    @Binding var showCreateLeague:Bool
    
    var body: some View {
        VStack {
            Text("Create a League")
                .font(.headline)
                .padding()
                .foregroundColor(ColorTheme.white).onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
           
                TextField("League Name", text: $leagueName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack{
                    TextField("Number of Users", text: $numberOfUsers)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Number of Weeks", text: $numberOfWeeks)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: numberOfWeeks) { newValue in
                            if let number = Int(newValue), !(1...8).contains(number) {
                                // If the entered value is not within the range 1...8,
                                // update the value to be within that range
                                numberOfWeeks = String(max(min(number, 8), 1))
                            }
                        }
                }
                Button(action: createLeague) {
                    Text("Create League")
                        .foregroundColor(.white)
                        .padding()
                        .background(ColorTheme.accent)
                        .cornerRadius(10)
                }
                Spacer()
            
        }
        .navigationBarHidden(false)
        .background(ColorTheme.accent.opacity(0.4))
        .cornerRadius(20)
    }
    
    func createLeague() {
        guard let numberOfWeeksInt = Int(numberOfWeeks) else {
            showAlert = true
            return
        }
        
        isLoading = true
        
//        // Assuming you have a function to make the API POST request
        leagueManager.createLeague(leagueName: leagueName, numberOfWeeks: numberOfWeeksInt, numberOfUsers: Int(numberOfUsers)!) { result in
            isLoading = false
            switch result {
            case .success:
                showCreateLeague = false
                leagueManager.getLeagues()
            case .failure(let error):
                print("Failed to create league: \(error)")
            }
        }
    }
}

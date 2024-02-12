//
//  CreateLeagueView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

struct CreateLeagueView: View {
    @State private var leagueName = ""
    @State private var numberOfWeeks = ""
    @State private var isLoading = false
    @State private var showAlert = false
    var leagueManager:LeagueManager
    
    var body: some View {
        VStack {
            Text("Create a League")
                .font(.largeTitle)
                .padding()
                .foregroundColor(ColorTheme.white)
            
            VStack(spacing: 20) {
                TextField("League Name", text: $leagueName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Number of Weeks", text: $numberOfWeeks)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: numberOfWeeks) { newValue in
                        if let number = Int(newValue), !(1...8).contains(number) {
                            // If the entered value is not within the range 1...8,
                            // update the value to be within that range
                            numberOfWeeks = String(max(min(number, 8), 1))
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
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success"), message: Text("League created successfully"), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(false)
        .background(ColorTheme.accent.opacity(0.9)) // Use a light gray background
        .cornerRadius(20) // Apply corner radius to VStack
        .padding(20) // Add padding to VStack
    }
    
    func createLeague() {
        guard let numberOfWeeksInt = Int(numberOfWeeks) else {
            showAlert = true
            return
        }
        
        isLoading = true
        
//        // Assuming you have a function to make the API POST request
        leagueManager.createLeague(leagueName: leagueName, numberOfWeeks: numberOfWeeksInt) { result in
            isLoading = false
            switch result {
            case .success:
                showAlert = true
            case .failure(let error):
                print("Failed to create league: \(error)")
            }
        }
    }
}

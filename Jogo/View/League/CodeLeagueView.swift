//
//  CodeLeagueView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import SwiftUI

struct CodeLeagueView: View {
    @Binding var code:String
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
        }
        .background(ColorTheme.accent.opacity(0.9)) // Use a light gray background
        .cornerRadius(20) // Apply corner radius to VStack
        .padding(20) // Add padding to VStack
    }
}

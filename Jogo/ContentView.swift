//
//  ContentView.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authViewModel = AuthenticationViewModel()
    var body: some View {
        if(authViewModel.accessDenied){
            Text("Invalid Authorization. Please log in.")
                                .foregroundColor(.red)
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(ColorTheme.white)
                                .cornerRadius(10)
        }
        Group {
            if(authViewModel.isLoggedIn){
                AppView(authViewModel: authViewModel)
            }else{
                LoginView(authViewModel: authViewModel)
            }
            
        }.background(ColorTheme.background)
    }
}

#Preview {
    ContentView()
}

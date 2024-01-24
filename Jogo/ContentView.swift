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

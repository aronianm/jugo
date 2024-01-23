//
//  AppDependancies.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import Foundation

// AppDependencies.swift
class AppDependencies: ObservableObject {
    static let shared = AppDependencies()

    @Published var authViewModel = AuthenticationViewModel()
}

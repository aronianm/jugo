//
//  Environment.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import Foundation

enum Environment {
    static var apiBaseURL: String {
        #if DEBUG
            return "http://michaels-macbook-air.local:3001"
        #else
            return "http://18.188.182.174"
        #endif
    }
}

//
//  Environment.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import Foundation



enum Environment {
    static var apiBaseURL: String {
        return ProcessInfo.processInfo.environment["API_BASE_URL"]!
    }
}

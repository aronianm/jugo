//
//  Environment.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import Foundation



enum Environment {
    static var apiBaseURL: String {
        guard let path = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") else{
            return ""
        }
        return "\(path)"
    }
}

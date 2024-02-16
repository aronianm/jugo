//
//  Environment.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import Foundation



enum Environment {
    static var apiBaseURL: String {
        #if isTestFlight
                return "http://qa.fogo-fitness.com"
        #elseif RELEASE
            return "http://production.fogo-fitness.com"
        #else
                return "http://michaels-macbook-air.local:3001"
        #endif
    }
}

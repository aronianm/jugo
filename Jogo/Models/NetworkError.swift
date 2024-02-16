//
//  NetworkError.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 2/8/24.
//

import Foundation
enum NetworkError: Error {
    case invalidURL
    case missingAuthorizationKey
    // Add more cases as needed to cover other potential network errors
}

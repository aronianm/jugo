//
//  User.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI
import Foundation
struct User: Identifiable, Codable {
    var id: Int
    var username:String
    
    func formattedName() -> String {
        return "\(username)"
    }
}


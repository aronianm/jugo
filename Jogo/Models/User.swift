//
//  User.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI
import Foundation
struct User: Identifiable, Codable {
    var id: Int
    var fname: String
    var lname: String
    
    func formattedName() -> String {
        let formattedFirstName = fname.capitalized
        let formattedLastName = lname.capitalized
        return "\(formattedFirstName) \(formattedLastName)"
    }
}

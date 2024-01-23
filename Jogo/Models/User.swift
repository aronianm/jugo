//
//  User.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import SwiftUI
class User: Identifiable, Codable {
    var id: Int
    var fname: String
    var lname: String
    
    
    func formattedName() -> String {
        return "\(fname) \(lname)"
    }
}

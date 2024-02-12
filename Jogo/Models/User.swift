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
    var wins:Int? = 5
    var losses:Int? = 3
    
    func formattedName() -> String {
        return "\(fname) \(lname)"
    }
}

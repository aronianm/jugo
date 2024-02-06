//
//  Matchup.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import Foundation
import SwiftUI
struct Matchup: Codable, Identifiable {
    var id: Int
    var isActive: Bool
    var isFinalized: Bool
    var userAccepted: Bool? = false
    var seasons:[Season]?
    var userOne:User
    var userTwo:User
    var currentUser:Int
    
    func opponentScore() -> String {
        return ""
    }
    func opponent() -> User {
        let u = currentUser == userOne.id ? userTwo : userOne
        return u
    }
    func userScore() -> String {
        return " "
    }
    func user() -> User {
        let u = currentUser == userOne.id ? userOne : userTwo
        return u
    }
    func opponentTitle() -> String {
        let u = currentUser == userOne.id ? userTwo : userOne
        return "\(u.fname) \(u.lname)"
    }
    
    func userTitle() -> String {
        let u = currentUser != userOne.id ? userTwo : userOne
        return "\(u.fname) \(u.lname)"
    }
}


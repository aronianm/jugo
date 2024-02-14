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
    var week:Int
    var seasons:[Season]?
    var userOne:User
    var currentUserScore:Float
    var userTwo:User
    var opponentScore:Float
    var currentUser:Int
    
    
    // Function to round a float to two decimal places and return it as a string
    private func roundedScore(_ score: Float) -> String {
        return String(format: "%.2f", score)
    }
    
    // Function to return opponent's score rounded to two decimal places
    func opponentScoreRounded() -> String {
        return roundedScore(opponentScore)
    }
    
    // Function to return current user's score rounded to two decimal places
    func currentUserScoreRounded() -> String {
        return roundedScore(currentUserScore)
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


//
//  Matchup.swift
//  Fogo
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
    var userOne:User
    var userTwo:User
    var userOneScore:Double
    var userTwoScore:Double
    var currentUser:Int?
    
    
    // Function to round a float to two decimal places and return it as a string
    private func roundedScore(_ score: Double) -> String {
        return String(format: "%.2f", score)
    }
    
    // Function to return opponent's score rounded to two decimal places
    func opponentScoreRounded() -> String {
        return roundedScore(userOneScore)
    }
    // Function to return current user's score rounded to two decimal places
    func currentUserScoreRounded() -> String {
        return roundedScore(userTwoScore)
    }
    func isUser() -> Bool {
        self.userOne.id == self.currentUser || self.userTwo.id == self.currentUser
    }
    
    func opponent() -> User {
        let u = userOne
        return u
    }
    func userScore() -> String {
        return " "
    }
    func user() -> User {
        let u = userTwo
        return u
    }
    func opponentTitle() -> String {
        let u = userOne
        return "\(u.username)"
    }
    
    func userTitle() -> String {
        let u = userTwo
        return "\(u.username)"
        
    }
}


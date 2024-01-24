//
//  Matchup.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/22/24.
//

import Foundation
import SwiftUI
struct Matchup: Codable, Identifiable {
    var id:Int
    var opponent: String
    var opponentScore:Int
    var userScore:Int
    var isActive: Bool
    var userAccepted:Bool?
}


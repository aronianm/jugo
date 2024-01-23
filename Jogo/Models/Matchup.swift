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
    var opponent: Opponent?
    var opponentScore:Int
    var userScore:Int
    var isActive: Bool
}


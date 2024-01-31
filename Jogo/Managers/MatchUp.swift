//
//  MatchUp.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/20/24.
//

import Foundation


struct Matchup: Codable, Identifiable {
    var id: UUID
    var opponent: Opponent
    var opponentScore:Int
    var userScore:Int
    var isActive:Bool
}

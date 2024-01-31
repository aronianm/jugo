//
//  Season.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/30/24.
//

import Foundation

struct Season: Codable, Identifiable {
    var id: Int
    var userOneWins: Int
    var userTwoWins: Int
    var matchup_id: Int
    var created_at: Date
    var updated_at: Date
}

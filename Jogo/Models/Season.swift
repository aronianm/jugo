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
    var seasonMatchup: [SeasonMatchup]?
    var matchup_id: Int
}

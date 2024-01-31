//
//  SeasonMatchup.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/30/24.
//

import Foundation

struct SeasonMatchup: Codable, Identifiable {
    var id: Int
    var week: Int
    var season_id: Int
    var userOneDailyScore: Float
    var userOneTotalScore: Float
    var userTwoDailyScore: Float
    var userTwoTotalScore: Float
    var userOneScoreUpdated: Date
    var userTwoScoreUpdated: Date
}

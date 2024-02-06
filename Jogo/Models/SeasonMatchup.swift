//
//  SeasonMatchup.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/30/24.
//

import Foundation

struct SeasonMatchup: Codable, Identifiable, Hashable {
    var id: Int
    var week: Int
    var season_id: Int
    var userOneDailyScore: Float
    var userOneTotalScore: Float
    var userTwoDailyScore: Float
    var userTwoTotalScore: Float
    var userOneFormattedScore:Float
    var userTwoFormattedScore:Float
    var startMatchup:Bool = false
    
    
    func userOpponentScore(user: User){
        
    }
    
}

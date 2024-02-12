//
//  League.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import Foundation

struct League:  Codable, Identifiable {
    var id: Int
    var leagueName: String
    var leagueCode: String?
    var numberOfWeeks:Int
    var userLeagues:[UserLeague]
}

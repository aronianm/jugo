//
//  UserLeague.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 2/11/24.
//

import Foundation
struct UserLeague:  Codable, Identifiable {
    var id:Int
    var user:User
    var wins:Int
    var losses:Int
}


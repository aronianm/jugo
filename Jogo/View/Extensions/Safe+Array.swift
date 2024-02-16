//
//  Safe+Array.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 2/13/24.
//

import Foundation
extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

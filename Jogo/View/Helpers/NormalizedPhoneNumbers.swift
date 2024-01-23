//
//  NormalizedPhoneNumbers.swift
//  Jogo
//
//  Created by Michael Aronian Aronian on 1/21/24.
//

import Foundation

private func normalizedPhoneNumber() -> String {
    // You may want to format the phone number in a standardized way, e.g., (123) 456-7890
    let formattedNumber = phoneNumber.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    return formattedNumber
}

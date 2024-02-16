//
//  ColorTheme.swift
//  Fogo
//
//  Created by Michael Aronian Aronian on 1/23/24.
//

import SwiftUI

enum ColorTheme {
    static var primary: Color {
        return Color(UIColor(hex: "415a77"))
    }
    
    static var secondary: Color {
        return Color(UIColor(hex: "778da9"))
    }
    
    static var disabledColor: Color {
        return Color(UIColor(hex: "e07a5f"))
    }
    
    static var warning:Color {
        return Color(UIColor(hex: "fee440"))
    }
    
    static var background: Color {
        return Color(UIColor(hex: "1b263b"))
    }
    
    static var accent: Color {
        return Color(UIColor(hex: "0d1b2a"))
    }
    
    static var white: Color{
        return Color(UIColor(hex: "FFFFFF"))
    }
    
    static var green: Color {
        return Color(UIColor(hex: "84a98c"))
    }
    static var blue: Color {
        return Color(UIColor(hex: "1b263b"))
    }
    static var barBlue: Color {
        return Color(UIColor(hex: "4361ee"))
    }
    static var red: Color {
        return Color(UIColor(hex: "e63946"))
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

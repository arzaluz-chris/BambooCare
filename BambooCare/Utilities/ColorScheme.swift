//
//  ColorScheme.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI

extension Color {
    // Primary Colors
    static let bambooPrimary = Color(red: 0.40, green: 0.70, blue: 0.42) // Natural bamboo green
    static let bambooSecondary = Color(red: 0.70, green: 0.92, blue: 0.75) // Light mint green

    // Neutrals
    static let textPrimary = Color(red: 0.17, green: 0.17, blue: 0.18) // Almost black #2C2C2E
    static let textSecondary = Color(red: 0.56, green: 0.56, blue: 0.58) // Gray

    // Earth Tones
    static let earthBeige = Color(red: 0.85, green: 0.82, blue: 0.76) // Beige accent
    static let earthBrown = Color(red: 0.55, green: 0.45, blue: 0.37) // Brown accent

    // Alerts
    static let wateringAlert = Color(red: 1.0, green: 0.75, blue: 0.28) // Amber/Yellow for urgent watering

    // Backgrounds
    static let backgroundGradientTop = Color(red: 0.95, green: 0.98, blue: 0.95) // Very light green
    static let backgroundGradientBottom = Color(red: 0.98, green: 0.97, blue: 0.94) // Off-white/bone
}

// Custom gradients
extension LinearGradient {
    static let bambooBackground = LinearGradient(
        gradient: Gradient(colors: [Color.backgroundGradientTop, Color.backgroundGradientBottom]),
        startPoint: .top,
        endPoint: .bottom
    )
}

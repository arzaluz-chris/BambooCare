//
//  ColorScheme.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI

extension Color {
    // MARK: - Bamboo Color Palette

    // Verde primario - Color principal de bambú
    static let bambooPrimary = Color(red: 0.40, green: 0.64, blue: 0.40) // #66A366

    // Verde secundario - Más claro, para fondos sutiles
    static let bambooSecondary = Color(red: 0.71, green: 0.85, blue: 0.71) // #B5D9B5

    // Verde oscuro - Para texto y acentos
    static let bambooDark = Color(red: 0.20, green: 0.40, blue: 0.20) // #336633

    // Verde muy claro - Para fondos
    static let bambooLight = Color(red: 0.93, green: 0.96, blue: 0.93) // #EEF5EE

    // MARK: - Accent Colors

    // Tonos tierra
    static let earthBrown = Color(red: 0.59, green: 0.49, blue: 0.40) // #967D66
    static let earthBeige = Color(red: 0.91, green: 0.87, blue: 0.80) // #E8DECE

    // MARK: - Status Colors

    // Estado de riego
    static let wateringNeeded = Color.red.opacity(0.8)
    static let wateringSoon = Color.orange.opacity(0.8)
    static let wateringOk = Color.green.opacity(0.8)

    // MARK: - Semantic Colors

    static let cardBackground = Color(uiColor: .systemBackground)
    static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let tertiaryBackground = Color(uiColor: .tertiarySystemBackground)

    // MARK: - Gradients

    static let bambooGradient = LinearGradient(
        colors: [bambooLight, bambooSecondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let headerGradient = LinearGradient(
        colors: [bambooPrimary, bambooDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.9), bambooLight],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Custom View Modifiers

struct BambooCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct BambooPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.bambooPrimary)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct BambooSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.bambooPrimary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.bambooLight)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.bambooPrimary, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - View Extensions

extension View {
    func bambooCard() -> some View {
        modifier(BambooCardStyle())
    }

    func bambooPrimaryButton() -> some View {
        buttonStyle(BambooPrimaryButtonStyle())
    }

    func bambooSecondaryButton() -> some View {
        buttonStyle(BambooSecondaryButtonStyle())
    }
}

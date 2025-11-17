//
//  OnboardingView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            LinearGradient.bambooBackground
                .ignoresSafeArea()

            VStack {
                TabView(selection: $currentPage) {
                    WelcomePage()
                        .tag(0)

                    PermissionsPage()
                        .tag(1)

                    ReadyPage(onComplete: {
                        hasCompletedOnboarding = true
                    })
                    .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
        }
    }
}

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "leaf.fill")
                .font(.system(size: 100))
                .foregroundStyle(.bambooPrimary)

            Text("Bienvenido a BambooCare")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)
                .multilineTextAlignment(.center)

            Text("Tu asistente definitivo para el cuidado de plantas de bambú")
                .font(.title3)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            VStack(spacing: 20) {
                FeatureRow(icon: "drop.fill", title: "Recordatorios Inteligentes", description: "Te avisamos cuándo regar basado en el clima")

                FeatureRow(icon: "cloud.sun.fill", title: "Integración del Clima", description: "Ajustamos consejos según el tiempo local")

                FeatureRow(icon: "book.fill", title: "Guía de Cuidados", description: "Soluciona problemas y aprende más")
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

struct PermissionsPage: View {
    @State private var notificationPermissionGranted = false
    @State private var locationPermissionGranted = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 80))
                .foregroundStyle(.bambooPrimary)

            Text("Permisos")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            Text("Para ofrecerte la mejor experiencia, necesitamos algunos permisos")
                .font(.body)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(spacing: 20) {
                PermissionCard(
                    icon: "bell.fill",
                    title: "Notificaciones",
                    description: "Para recordarte cuándo regar tus plantas",
                    isGranted: $notificationPermissionGranted,
                    action: requestNotificationPermission
                )

                PermissionCard(
                    icon: "location.fill",
                    title: "Ubicación",
                    description: "Para ajustar los consejos según el clima local",
                    isGranted: $locationPermissionGranted,
                    action: requestLocationPermission
                )
            }
            .padding()

            Spacer()

            Text("Puedes cambiar estos permisos en Ajustes en cualquier momento")
                .font(.caption)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                notificationPermissionGranted = granted
            }
        }
    }

    private func requestLocationPermission() {
        // This would trigger the location manager to request permission
        // For now, we'll just set it to true as a placeholder
        locationPermissionGranted = true
    }
}

struct ReadyPage: View {
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundStyle(.bambooPrimary)

            Text("¡Todo listo!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.textPrimary)

            Text("Comienza a añadir tus primeras plantas de bambú")
                .font(.title3)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            Button {
                onComplete()
            } label: {
                Text("Comenzar")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.bambooPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.bambooPrimary)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.textPrimary)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.textSecondary)
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PermissionCard: View {
    let icon: String
    let title: String
    let description: String
    @Binding var isGranted: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.bambooPrimary)
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.textPrimary)

                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.textSecondary)
                }

                Spacer()

                if isGranted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.bambooPrimary)
                }
            }

            if !isGranted {
                Button {
                    action()
                } label: {
                    Text("Permitir")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(.bambooPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    OnboardingView()
}

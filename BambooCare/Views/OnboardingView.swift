//
//  OnboardingView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var locationManager = LocationManager.shared

    @State private var currentPage = 0
    @State private var showAddPlantWizard = false

    var body: some View {
        ZStack {
            // Fondo con gradiente
            Color.bambooGradient
                .ignoresSafeArea()

            TabView(selection: $currentPage) {
                // Página 1: Bienvenida
                WelcomePage()
                    .tag(0)

                // Página 2: Permisos de Notificaciones
                NotificationPermissionPage(notificationManager: notificationManager)
                    .tag(1)

                // Página 3: Permiso de Ubicación
                LocationPermissionPage(locationManager: locationManager)
                    .tag(2)

                // Página 4: Listo para empezar
                ReadyPage(showAddPlantWizard: $showAddPlantWizard)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .sheet(isPresented: $showAddPlantWizard) {
            AddPlantWizardView(isFirstPlant: true) {
                dismiss()
            }
        }
    }
}

// MARK: - Welcome Page

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "leaf.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.bambooPrimary)

            Text("Bienvenido a")
                .font(.title2)
                .foregroundColor(.bambooDark)

            Text("BambooCare")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.bambooPrimary)

            Text("Tu asistente personal para el cuidado de plantas de bambú")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.bambooDark)
                .padding(.horizontal, 40)

            Spacer()

            Text("Desliza para continuar")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 40)
        }
    }
}

// MARK: - Notification Permission Page

struct NotificationPermissionPage: View {
    @ObservedObject var notificationManager: NotificationManager
    @State private var isRequesting = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "bell.badge.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.bambooPrimary)

            Text("Recordatorios de Riego")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.bambooDark)

            Text("Recibe notificaciones para saber cuándo es el momento perfecto para regar tus plantas")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.bambooDark)
                .padding(.horizontal, 40)

            if notificationManager.authorizationStatus == .authorized {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Permisos concedidos")
                        .foregroundColor(.green)
                }
                .padding()
            } else if notificationManager.authorizationStatus == .denied {
                Text("Puedes activar las notificaciones en Ajustes")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                Button {
                    Task {
                        isRequesting = true
                        _ = await notificationManager.requestAuthorization()
                        isRequesting = false
                    }
                } label: {
                    if isRequesting {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Permitir Notificaciones")
                    }
                }
                .bambooPrimaryButton()
                .padding(.horizontal, 40)
            }

            Spacer()
        }
    }
}

// MARK: - Location Permission Page

struct LocationPermissionPage: View {
    @ObservedObject var locationManager: LocationManager

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "location.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.bambooPrimary)

            Text("Ubicación")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.bambooDark)

            Text("Usamos tu ubicación para ajustar los consejos de riego según el clima de tu zona")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.bambooDark)
                .padding(.horizontal, 40)

            Text("(Opcional)")
                .font(.caption)
                .foregroundColor(.secondary)

            if locationManager.authorizationStatus == .authorizedWhenInUse ||
               locationManager.authorizationStatus == .authorizedAlways {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Permisos concedidos")
                        .foregroundColor(.green)
                }
                .padding()
            } else if locationManager.authorizationStatus == .denied {
                VStack {
                    Text("Puedes activar la ubicación en Ajustes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()

                    Text("También puedes introducir tu ciudad manualmente más tarde")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(spacing: 15) {
                    Button("Permitir Ubicación") {
                        locationManager.requestAuthorization()
                    }
                    .bambooPrimaryButton()
                    .padding(.horizontal, 40)

                    Button("Omitir") {
                        // No hace nada, el usuario puede deslizar
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
    }
}

// MARK: - Ready Page

struct ReadyPage: View {
    @Binding var showAddPlantWizard: Bool

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.bambooPrimary)

            Text("¡Todo Listo!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.bambooDark)

            Text("Ahora vamos a añadir tu primera planta de bambú")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.bambooDark)
                .padding(.horizontal, 40)

            Spacer()

            Button("Añadir Mi Primera Planta") {
                showAddPlantWizard = true
            }
            .bambooPrimaryButton()
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    OnboardingView()
}

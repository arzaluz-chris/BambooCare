//
//  SettingsView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var plants: [BambooPlant]

    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var weatherService = WeatherService.shared

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @AppStorage("enableNotifications") private var enableNotifications = true
    @AppStorage("userCity") private var userCity = ""

    @State private var showLocationPicker = false
    @State private var tempCity = ""
    @State private var weatherSummary = ""

    var body: some View {
        NavigationStack {
            List {
                // Sección de Notificaciones
                Section {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.bambooPrimary)
                        Text("Notificaciones")

                        Spacer()

                        if notificationManager.authorizationStatus == .authorized {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else if notificationManager.authorizationStatus == .denied {
                            Text("Denegado")
                                .font(.caption)
                                .foregroundColor(.red)
                        } else {
                            Button("Activar") {
                                Task {
                                    await notificationManager.requestAuthorization()
                                }
                            }
                            .font(.caption)
                        }
                    }

                    if notificationManager.authorizationStatus == .authorized {
                        Button("Reprogramar Todos los Recordatorios") {
                            notificationManager.scheduleAllWateringReminders(for: plants)
                        }
                    }
                } header: {
                    Text("Recordatorios")
                } footer: {
                    Text("Activa las notificaciones para recibir recordatorios de riego.")
                }

                // Sección de Ubicación
                Section {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.bambooPrimary)
                        Text("Ubicación")

                        Spacer()

                        if locationManager.isAuthorized {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else if locationManager.authorizationStatus == .denied {
                            Text("Denegado")
                                .font(.caption)
                                .foregroundColor(.red)
                        } else {
                            Button("Activar") {
                                locationManager.requestAuthorization()
                            }
                            .font(.caption)
                        }
                    }

                    if locationManager.isAuthorized {
                        Button("Obtener Ubicación Actual") {
                            locationManager.requestLocation()
                        }

                        if let location = locationManager.currentLocation {
                            Text("Lat: \(location.coordinate.latitude, specifier: "%.2f"), Lon: \(location.coordinate.longitude, specifier: "%.2f")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Button("Introducir Ciudad Manualmente") {
                            showLocationPicker = true
                        }

                        if !userCity.isEmpty {
                            Text("Ciudad: \(userCity)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Ubicación y Clima")
                } footer: {
                    Text("Usamos tu ubicación para ajustar los consejos de riego según el clima local.")
                }

                // Sección de Clima
                Section {
                    if !weatherSummary.isEmpty {
                        HStack {
                            Image(systemName: "cloud.sun.fill")
                                .foregroundColor(.bambooPrimary)
                            Text(weatherSummary)
                                .font(.subheadline)
                        }
                    }

                    Button("Actualizar Clima") {
                        updateWeather()
                    }
                } header: {
                    Text("Información del Clima")
                }

                // Sección de Datos
                Section {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.bambooPrimary)
                        Text("Plantas registradas")
                        Spacer()
                        Text("\(plants.count)")
                            .foregroundColor(.secondary)
                    }

                    Button(role: .destructive) {
                        // Resetear onboarding
                        hasCompletedOnboarding = false
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reiniciar Tutorial")
                        }
                    }
                } header: {
                    Text("Datos de la App")
                }

                // Sección Acerca de
                Section {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    Link(destination: URL(string: "https://github.com")!) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("Acerca de BambooCare")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }
                } header: {
                    Text("Información")
                }
            }
            .navigationTitle("Ajustes")
            .sheet(isPresented: $showLocationPicker) {
                CityPickerView(city: $userCity, tempCity: $tempCity)
            }
            .task {
                updateWeather()
            }
        }
    }

    private func updateWeather() {
        Task {
            if let location = locationManager.currentLocation {
                await weatherService.fetchWeather(for: location)
                weatherSummary = weatherService.getWeatherSummary()
            } else if !userCity.isEmpty {
                if let location = await locationManager.getCoordinates(for: userCity) {
                    await weatherService.fetchWeather(for: location)
                    weatherSummary = weatherService.getWeatherSummary()
                }
            }
        }
    }
}

// MARK: - City Picker View

struct CityPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var city: String
    @Binding var tempCity: String

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Nombre de la ciudad", text: $tempCity)
                } header: {
                    Text("Ciudad")
                } footer: {
                    Text("Introduce el nombre de tu ciudad para obtener información del clima local.")
                }
            }
            .navigationTitle("Ubicación Manual")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        city = tempCity
                        dismiss()
                    }
                    .disabled(tempCity.isEmpty)
                }
            }
            .onAppear {
                tempCity = city
            }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [BambooPlant.self, Species.self, CareLog.self])
}

//
//  SettingsView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("useMetricUnits") private var useMetricUnits = true

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.bambooBackground
                    .ignoresSafeArea()

                Form {
                    Section {
                        Toggle("Notificaciones de Riego", isOn: $notificationsEnabled)

                        Toggle("Usar Unidades Métricas", isOn: $useMetricUnits)
                    } header: {
                        Text("Preferencias")
                    } footer: {
                        Text("Las notificaciones te recordarán cuándo regar tus plantas")
                    }

                    Section {
                        HStack {
                            Text("Ubicación")
                            Spacer()
                            Text("Automática")
                                .foregroundStyle(.textSecondary)
                        }

                        Button {
                            // Request location permission
                        } label: {
                            Text("Actualizar Ubicación")
                        }
                    } header: {
                        Text("Ubicación")
                    } footer: {
                        Text("Usamos tu ubicación para ajustar los consejos de riego según el clima local")
                    }

                    Section {
                        HStack {
                            Text("Versión")
                            Spacer()
                            Text("1.0.0")
                                .foregroundStyle(.textSecondary)
                        }

                        Link("Política de Privacidad", destination: URL(string: "https://example.com/privacy")!)
                        Link("Términos de Uso", destination: URL(string: "https://example.com/terms")!)
                    } header: {
                        Text("Acerca de")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Ajustes")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsView()
}

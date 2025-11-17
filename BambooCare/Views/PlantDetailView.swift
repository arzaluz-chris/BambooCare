//
//  PlantDetailView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct PlantDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var plant: BambooPlant
    @StateObject private var notificationManager = NotificationManager.shared

    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    @State private var showAddCareLog = false
    @State private var selectedCareType: CareType = .riego

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Hero Image
                    PlantHeroImage(plant: plant)

                    // Información básica
                    PlantInfoSection(plant: plant)

                    // Estado de riego
                    WateringStatusSection(plant: plant, notificationManager: notificationManager)

                    // Acciones rápidas
                    QuickActionsSection(
                        plant: plant,
                        showAddCareLog: $showAddCareLog,
                        selectedCareType: $selectedCareType
                    )

                    // Historial de cuidados
                    CareHistorySection(plant: plant)
                }
                .padding()
            }
            .background(Color.bambooLight)
            .navigationTitle(plant.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showEditSheet = true
                        } label: {
                            Label("Editar", systemImage: "pencil")
                        }

                        Button(role: .destructive) {
                            showDeleteAlert = true
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showAddCareLog) {
                AddCareLogView(plant: plant, careType: selectedCareType)
            }
            .alert("Eliminar Planta", isPresented: $showDeleteAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Eliminar", role: .destructive) {
                    deletePlant()
                }
            } message: {
                Text("¿Estás seguro de que quieres eliminar \(plant.name)?")
            }
        }
    }

    private func deletePlant() {
        notificationManager.cancelWateringReminder(for: plant)
        modelContext.delete(plant)
        dismiss()
    }
}

// MARK: - Plant Hero Image

struct PlantHeroImage: View {
    let plant: BambooPlant

    var body: some View {
        if let photoData = plant.photo,
           let uiImage = UIImage(data: photoData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        } else {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.bambooSecondary)
                .frame(height: 300)
                .overlay(
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.bambooPrimary)
                )
        }
    }
}

// MARK: - Plant Info Section

struct PlantInfoSection: View {
    let plant: BambooPlant

    var body: some View {
        VStack(spacing: 12) {
            if let species = plant.species {
                InfoRow(icon: "leaf.circle.fill", title: "Especie", value: species.commonName)
                InfoRow(icon: "character.book.closed.fill", title: "Nombre Científico", value: species.scientificName)
            }

            InfoRow(icon: plant.location == .interior ? "house.fill" : "sun.max.fill",
                   title: "Ubicación",
                   value: plant.location.description)

            InfoRow(icon: plant.lightLevel.icon,
                   title: "Nivel de Luz",
                   value: plant.lightLevel.description)

            InfoRow(icon: plant.container.icon,
                   title: "Contenedor",
                   value: plant.container.description)

            if let notes = plant.notes, !notes.isEmpty {
                InfoRow(icon: "note.text", title: "Notas", value: notes)
            }
        }
        .padding()
        .bambooCard()
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.bambooPrimary)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }

            Spacer()
        }
    }
}

// MARK: - Watering Status Section

struct WateringStatusSection: View {
    @Bindable var plant: BambooPlant
    let notificationManager: NotificationManager

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.title)
                    .foregroundColor(.blue)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Estado de Riego")
                        .font(.headline)

                    Text(plant.wateringStatus)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(statusColor)
                }

                Spacer()
            }

            if let lastWatered = plant.lastWatered {
                Text("Último riego: \(lastWatered.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let species = plant.species {
                Text(species.waterAmountGuide)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .bambooCard()
    }

    private var statusColor: Color {
        switch plant.wateringStatusColor {
        case "red":
            return .wateringNeeded
        case "orange":
            return .wateringSoon
        default:
            return .wateringOk
        }
    }
}

// MARK: - Quick Actions Section

struct QuickActionsSection: View {
    @Bindable var plant: BambooPlant
    @Binding var showAddCareLog: Bool
    @Binding var selectedCareType: CareType

    var body: some View {
        VStack(spacing: 12) {
            Button {
                markAsWatered()
            } label: {
                HStack {
                    Image(systemName: "drop.fill")
                    Text("Marcar como Regado")
                }
            }
            .bambooPrimaryButton()

            Button {
                plant.postponeWatering(days: 1)
            } label: {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Aplazar Riego 1 Día")
                }
            }
            .bambooSecondaryButton()

            Menu {
                ForEach(CareType.allCases, id: \.self) { type in
                    Button {
                        selectedCareType = type
                        showAddCareLog = true
                    } label: {
                        Label(type.description, systemImage: type.icon)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Registrar Cuidado")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.bambooLight)
                .foregroundColor(.bambooPrimary)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.bambooPrimary, lineWidth: 2)
                )
            }
        }
    }

    private func markAsWatered() {
        let careLog = CareLog(type: .riego, notes: "Regado manualmente")
        plant.addCareLog(careLog)

        // Reprogramar notificación
        NotificationManager.shared.scheduleWateringReminder(for: plant)
    }
}

// MARK: - Care History Section

struct CareHistorySection: View {
    let plant: BambooPlant

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Historial de Cuidados")
                .font(.headline)

            if plant.careHistory.isEmpty {
                Text("No hay registros aún")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(plant.careHistory.sorted(by: { $0.date > $1.date }).prefix(10)) { log in
                    CareLogRow(log: log)
                }
            }
        }
        .padding()
        .bambooCard()
    }
}

struct CareLogRow: View {
    let log: CareLog

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: log.type.icon)
                .foregroundColor(.bambooPrimary)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(log.type.description)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(log.relativeDate)
                    .font(.caption)
                    .foregroundColor(.secondary)

                if !log.notes.isEmpty {
                    Text(log.notes)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Add Care Log View

struct AddCareLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let plant: BambooPlant
    let careType: CareType

    @State private var notes = ""
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Tipo de Cuidado") {
                    HStack {
                        Image(systemName: careType.icon)
                        Text(careType.description)
                    }
                }

                Section("Fecha") {
                    DatePicker("Fecha", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Notas") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Registrar Cuidado")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveCareLog()
                    }
                }
            }
        }
    }

    private func saveCareLog() {
        let log = CareLog(date: selectedDate, type: careType, notes: notes)
        plant.addCareLog(log)

        if careType == .riego {
            NotificationManager.shared.scheduleWateringReminder(for: plant)
        }

        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BambooPlant.self, Species.self, CareLog.self, configurations: config)

    let species = Species(
        commonName: "Bambú de la Suerte",
        scientificName: "Dracaena sanderiana",
        descriptionText: "Test",
        baseWateringFrequencyDays: 7,
        waterAmountGuide: "Cambia el agua semanalmente"
    )

    let plant = BambooPlant(
        name: "Mi Bambú",
        location: .interior,
        lightLevel: .indirecta,
        container: .jarronAgua,
        species: species
    )

    container.mainContext.insert(plant)

    return PlantDetailView(plant: plant)
        .modelContainer(container)
}

//
//  PlantDetailView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI
import SwiftData

struct PlantDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var plant: BambooPlant
    @State private var showingEditSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero Image
                plantImageSection

                // Watering Status Card
                wateringStatusCard

                // Quick Actions
                quickActionsSection

                // Care History
                careHistorySection
            }
            .padding()
        }
        .background(LinearGradient.bambooBackground.ignoresSafeArea())
        .navigationTitle(plant.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Editar") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditPlantView(plant: plant)
        }
    }

    private var plantImageSection: some View {
        Group {
            if let photoData = plant.photoData,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                ZStack {
                    Color.bambooSecondary
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.bambooPrimary.opacity(0.5))
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }

    private var wateringStatusCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.title2)
                    .foregroundStyle(.bambooPrimary)

                Text("Estado de Riego")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.textPrimary)

                Spacer()
            }

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(plant.wateringStatus)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(statusColor)

                    if let lastWatered = plant.lastWatered {
                        Text("Último riego: \(lastWatered, style: .date)")
                            .font(.caption)
                            .foregroundStyle(.textSecondary)
                    } else {
                        Text("Aún no has regado esta planta")
                            .font(.caption)
                            .foregroundStyle(.textSecondary)
                    }

                    if let species = plant.species {
                        Text(species.waterAmountGuide)
                            .font(.caption)
                            .foregroundStyle(.textSecondary)
                            .padding(.top, 4)
                    }
                }

                Spacer()
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var quickActionsSection: some View {
        VStack(spacing: 12) {
            Button {
                markAsWatered()
            } label: {
                HStack {
                    Image(systemName: "drop.fill")
                    Text("Marcar como Regado")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.bambooPrimary)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                postponeWatering()
            } label: {
                HStack {
                    Image(systemName: "clock.fill")
                    Text("Aplazar Riego 1 Día")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .foregroundStyle(.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var careHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Historial de Cuidados")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.textPrimary)

            if plant.careHistory.isEmpty {
                Text("No hay registros de cuidados aún")
                    .font(.body)
                    .foregroundStyle(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(plant.careHistory.sorted(by: { $0.date > $1.date })) { log in
                    CareLogRow(log: log)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var statusColor: Color {
        if plant.wateringStatus.contains("hoy") {
            return .wateringAlert
        } else {
            return .bambooPrimary
        }
    }

    private func markAsWatered() {
        plant.lastWatered = Date()

        let log = CareLog(date: Date(), type: .watering, notes: "Planta regada")
        log.plant = plant
        modelContext.insert(log)
    }

    private func postponeWatering() {
        if let lastWatered = plant.lastWatered {
            plant.lastWatered = Calendar.current.date(byAdding: .day, value: 1, to: lastWatered)
        }
    }
}

struct CareLogRow: View {
    let log: CareLog

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconForCareType(log.type))
                .foregroundStyle(.bambooPrimary)
                .font(.title3)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(log.type.rawValue)
                    .font(.headline)
                    .foregroundStyle(.textPrimary)

                Text(log.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.textSecondary)

                if !log.notes.isEmpty {
                    Text(log.notes)
                        .font(.caption)
                        .foregroundStyle(.textSecondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }

    private func iconForCareType(_ type: CareType) -> String {
        switch type {
        case .watering:
            return "drop.fill"
        case .fertilizer:
            return "sparkles"
        case .pruning:
            return "scissors"
        case .photo:
            return "camera.fill"
        }
    }
}

// Placeholder for EditPlantView
struct EditPlantView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var plant: BambooPlant

    var body: some View {
        NavigationStack {
            Form {
                Section("Información Básica") {
                    TextField("Nombre", text: $plant.name)
                }

                Section("Ubicación") {
                    Picker("Ubicación", selection: $plant.location) {
                        ForEach(PlantLocation.allCases, id: \.self) { location in
                            Text(location.rawValue).tag(location)
                        }
                    }

                    Picker("Nivel de Luz", selection: $plant.lightLevel) {
                        ForEach(LightLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }

                    Picker("Contenedor", selection: $plant.container) {
                        ForEach(ContainerType.allCases, id: \.self) { container in
                            Text(container.rawValue).tag(container)
                        }
                    }
                }
            }
            .navigationTitle("Editar Planta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: BambooPlant.self, Species.self, CareLog.self, configurations: config)

    let plant = BambooPlant(name: "Bambú de Oficina", location: .interior, lightLevel: .indirect, container: .pot)
    container.mainContext.insert(plant)

    return NavigationStack {
        PlantDetailView(plant: plant)
    }
    .modelContainer(container)
}

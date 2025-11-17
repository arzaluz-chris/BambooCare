//
//  DashboardView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \BambooPlant.addedDate, order: .reverse) private var plants: [BambooPlant]

    @State private var showAddPlant = false
    @State private var selectedPlant: BambooPlant?

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo con gradiente sutil
                Color.bambooLight.ignoresSafeArea()

                if plants.isEmpty {
                    // Vista vacía
                    EmptyDashboardView(showAddPlant: $showAddPlant)
                } else {
                    // Lista de plantas
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(plants) { plant in
                                PlantCard(plant: plant)
                                    .onTapGesture {
                                        selectedPlant = plant
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Mis Bambús")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddPlant = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.bambooPrimary)
                    }
                }
            }
            .sheet(isPresented: $showAddPlant) {
                AddPlantWizardView(isFirstPlant: false)
            }
            .sheet(item: $selectedPlant) { plant in
                PlantDetailView(plant: plant)
            }
        }
    }
}

// MARK: - Empty Dashboard View

struct EmptyDashboardView: View {
    @Binding var showAddPlant: Bool

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "leaf")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.bambooPrimary.opacity(0.5))

            Text("No tienes plantas aún")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.bambooDark)

            Text("Añade tu primera planta de bambú para comenzar a cuidarla")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)

            Button("Añadir Planta") {
                showAddPlant = true
            }
            .bambooPrimaryButton()
            .frame(width: 200)
        }
    }
}

// MARK: - Plant Card

struct PlantCard: View {
    let plant: BambooPlant

    var body: some View {
        HStack(spacing: 16) {
            // Foto de la planta
            if let photoData = plant.photo,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                // Placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.bambooSecondary)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "leaf.fill")
                            .font(.largeTitle)
                            .foregroundColor(.bambooPrimary)
                    )
            }

            // Información de la planta
            VStack(alignment: .leading, spacing: 8) {
                Text(plant.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                if let species = plant.species {
                    Text(species.commonName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .font(.caption)
                        .foregroundColor(wateringStatusColor)

                    Text(plant.wateringStatus)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(wateringStatusColor)
                }
            }

            Spacer()

            // Indicador de estado
            Circle()
                .fill(wateringStatusColor)
                .frame(width: 12, height: 12)
        }
        .padding()
        .bambooCard()
    }

    private var wateringStatusColor: Color {
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

#Preview {
    DashboardView()
        .modelContainer(for: [BambooPlant.self, Species.self, CareLog.self])
}

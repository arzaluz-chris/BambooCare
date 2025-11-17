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
    @Query private var plants: [BambooPlant]
    @State private var showingAddPlant = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient.bambooBackground
                    .ignoresSafeArea()

                if plants.isEmpty {
                    emptyStateView
                } else {
                    plantsGridView
                }
            }
            .navigationTitle("Mis Bambús")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPlant = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.bambooPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingAddPlant) {
                AddPlantWizardView()
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 70))
                .foregroundStyle(.bambooPrimary)

            Text("No tienes bambús registrados")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.textPrimary)

            Text("Toca el botón + para añadir tu primera planta")
                .font(.body)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                showingAddPlant = true
            } label: {
                Text("Añadir Bambú")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.bambooPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.top)
        }
    }

    private var plantsGridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                ForEach(plants) { plant in
                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                        PlantCardView(plant: plant)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}

struct PlantCardView: View {
    let plant: BambooPlant

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Plant image
            if let photoData = plant.photoData,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
            } else {
                ZStack {
                    Color.bambooSecondary
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.bambooPrimary.opacity(0.5))
                }
                .frame(height: 120)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(plant.name)
                    .font(.headline)
                    .foregroundStyle(.textPrimary)
                    .lineLimit(1)

                Text(plant.wateringStatus)
                    .font(.caption)
                    .foregroundStyle(statusColor)
                    .fontWeight(.medium)

                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .font(.caption2)
                    Text(plant.lastWatered != nil ? "Último riego: \(plant.lastWatered!, style: .relative)" : "Sin riego")
                        .font(.caption2)
                }
                .foregroundStyle(.textSecondary)
            }
            .padding(12)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    private var statusColor: Color {
        if plant.wateringStatus.contains("hoy") {
            return .wateringAlert
        } else {
            return .bambooPrimary
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [BambooPlant.self, Species.self, CareLog.self])
}

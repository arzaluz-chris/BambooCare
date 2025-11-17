//
//  AddPlantWizardView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddPlantWizardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var allSpecies: [Species]

    @State private var currentStep = 0
    @State private var plantName = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var selectedSpecies: Species?
    @State private var location: PlantLocation = .interior
    @State private var container: ContainerType = .pot
    @State private var lightLevel: LightLevel = .indirect

    private let steps = ["Nombre", "Foto", "Especie", "Detalles"]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.bambooBackground
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Progress indicator
                    ProgressView(value: Double(currentStep + 1), total: Double(steps.count))
                        .tint(.bambooPrimary)
                        .padding()

                    Text("Paso \(currentStep + 1) de \(steps.count)")
                        .font(.caption)
                        .foregroundStyle(.textSecondary)

                    // Content
                    TabView(selection: $currentStep) {
                        nameStepView
                            .tag(0)

                        photoStepView
                            .tag(1)

                        speciesStepView
                            .tag(2)

                        detailsStepView
                            .tag(3)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    // Navigation buttons
                    HStack(spacing: 16) {
                        if currentStep > 0 {
                            Button {
                                withAnimation {
                                    currentStep -= 1
                                }
                            } label: {
                                Text("Anterior")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .foregroundStyle(.textPrimary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }

                        Button {
                            if currentStep < steps.count - 1 {
                                withAnimation {
                                    currentStep += 1
                                }
                            } else {
                                savePlant()
                            }
                        } label: {
                            Text(currentStep < steps.count - 1 ? "Siguiente" : "Guardar")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.bambooPrimary)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(!isCurrentStepValid)
                    }
                    .padding()
                }
            }
            .navigationTitle("Añadir Bambú")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            createDefaultSpeciesIfNeeded()
        }
    }

    private var nameStepView: some View {
        VStack(spacing: 16) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 60))
                .foregroundStyle(.bambooPrimary)
                .padding()

            Text("¿Cómo se llama tu bambú?")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.textPrimary)

            Text("Dale un nombre único para identificarlo fácilmente")
                .font(.body)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("Ej: Bambú de la oficina", text: $plantName)
                .textFieldStyle(.roundedBorder)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
        }
        .padding()
    }

    private var photoStepView: some View {
        VStack(spacing: 16) {
            if let photoData = photoData,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                ZStack {
                    Color.bambooSecondary
                    Image(systemName: "camera.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.bambooPrimary.opacity(0.5))
                }
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }

            Text("Añade una foto")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.textPrimary)

            Text("Una foto te ayudará a identificar tu planta")
                .font(.body)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                HStack {
                    Image(systemName: "photo.fill")
                    Text(photoData == nil ? "Seleccionar Foto" : "Cambiar Foto")
                }
                .padding()
                .background(.bambooPrimary)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .onChange(of: selectedPhoto) { _, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }

            Button {
                withAnimation {
                    currentStep += 1
                }
            } label: {
                Text("Omitir")
                    .foregroundStyle(.textSecondary)
            }
        }
        .padding()
    }

    private var speciesStepView: some View {
        VStack(spacing: 16) {
            Image(systemName: "list.bullet.rectangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.bambooPrimary)
                .padding()

            Text("¿Qué tipo de bambú es?")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.textPrimary)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(allSpecies) { species in
                        Button {
                            selectedSpecies = species
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(species.commonName)
                                        .font(.headline)
                                        .foregroundStyle(.textPrimary)

                                    Text(species.scientificName)
                                        .font(.caption)
                                        .foregroundStyle(.textSecondary)
                                        .italic()
                                }

                                Spacer()

                                if selectedSpecies?.id == species.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.bambooPrimary)
                                }
                            }
                            .padding()
                            .background(selectedSpecies?.id == species.id ? Color.bambooSecondary : Color.clear)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }

    private var detailsStepView: some View {
        VStack(spacing: 16) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.bambooPrimary)
                .padding()

            Text("Detalles de ubicación")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.textPrimary)

            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ubicación")
                        .font(.headline)
                        .foregroundStyle(.textPrimary)

                    Picker("", selection: $location) {
                        ForEach(PlantLocation.allCases, id: \.self) { loc in
                            Text(loc.rawValue).tag(loc)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Contenedor")
                        .font(.headline)
                        .foregroundStyle(.textPrimary)

                    Picker("", selection: $container) {
                        ForEach(ContainerType.allCases, id: \.self) { cont in
                            Text(cont.rawValue).tag(cont)
                        }
                    }
                    .pickerStyle(.menu)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Nivel de Luz")
                        .font(.headline)
                        .foregroundStyle(.textPrimary)

                    Picker("", selection: $lightLevel) {
                        ForEach(LightLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
        }
        .padding()
    }

    private var isCurrentStepValid: Bool {
        switch currentStep {
        case 0:
            return !plantName.isEmpty
        case 2:
            return selectedSpecies != nil
        default:
            return true
        }
    }

    private func savePlant() {
        let newPlant = BambooPlant(
            name: plantName,
            location: location,
            lightLevel: lightLevel,
            container: container
        )

        newPlant.species = selectedSpecies
        newPlant.photoData = photoData

        modelContext.insert(newPlant)

        dismiss()
    }

    private func createDefaultSpeciesIfNeeded() {
        if allSpecies.isEmpty {
            let defaultSpecies = [
                Species(
                    commonName: "Bambú de la Suerte",
                    scientificName: "Dracaena sanderiana",
                    descriptionText: "Popular planta de interior que crece en agua o tierra.",
                    baseWateringFrequencyDays: 7,
                    waterAmountGuide: "Mantén el agua limpia y cambia semanalmente"
                ),
                Species(
                    commonName: "Bambú Dorado",
                    scientificName: "Phyllostachys aurea",
                    descriptionText: "Bambú verdadero de crecimiento medio, ideal para jardines.",
                    baseWateringFrequencyDays: 3,
                    waterAmountGuide: "Mantén el suelo húmedo pero no encharcado"
                ),
                Species(
                    commonName: "Bambú Negro",
                    scientificName: "Phyllostachys nigra",
                    descriptionText: "Bambú ornamental con cañas que se vuelven negras con el tiempo.",
                    baseWateringFrequencyDays: 4,
                    waterAmountGuide: "Riego regular, especialmente en verano"
                )
            ]

            defaultSpecies.forEach { modelContext.insert($0) }
        }
    }
}

#Preview {
    AddPlantWizardView()
        .modelContainer(for: [BambooPlant.self, Species.self, CareLog.self])
}

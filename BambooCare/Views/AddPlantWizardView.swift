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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query private var allSpecies: [Species]

    let isFirstPlant: Bool
    var onComplete: (() -> Void)? = nil

    @State private var currentStep = 0
    @State private var plantName = ""
    @State private var selectedSpecies: Species?
    @State private var location: PlantLocation = .interior
    @State private var lightLevel: LightLevel = .indirecta
    @State private var container: ContainerType = .maceta
    @State private var notes = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?

    private let totalSteps = 5

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bambooLight.ignoresSafeArea()

                VStack(spacing: 20) {
                    // Progress indicator
                    ProgressView(value: Double(currentStep), total: Double(totalSteps))
                        .tint(.bambooPrimary)
                        .padding()

                    TabView(selection: $currentStep) {
                        // Step 1: Nombre
                        NameStep(plantName: $plantName)
                            .tag(0)

                        // Step 2: Especie
                        SpeciesStep(selectedSpecies: $selectedSpecies, allSpecies: allSpecies)
                            .tag(1)

                        // Step 3: Ubicación y Contenedor
                        LocationStep(location: $location, container: $container)
                            .tag(2)

                        // Step 4: Nivel de Luz
                        LightStep(lightLevel: $lightLevel)
                            .tag(3)

                        // Step 5: Foto y Notas
                        PhotoStep(selectedPhoto: $selectedPhoto, photoData: $photoData, notes: $notes)
                            .tag(4)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    // Navigation buttons
                    HStack(spacing: 16) {
                        if currentStep > 0 {
                            Button("Anterior") {
                                withAnimation {
                                    currentStep -= 1
                                }
                            }
                            .bambooSecondaryButton()
                        }

                        Button(currentStep == totalSteps - 1 ? "Finalizar" : "Siguiente") {
                            if currentStep == totalSteps - 1 {
                                savePlant()
                            } else {
                                withAnimation {
                                    currentStep += 1
                                }
                            }
                        }
                        .bambooPrimaryButton()
                        .disabled(!canProceed)
                    }
                    .padding()
                }
            }
            .navigationTitle("Añadir Planta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !isFirstPlant {
                        Button("Cancelar") {
                            dismiss()
                        }
                    }
                }
            }
            .task {
                // Inicializar especies predeterminadas si no existen
                if allSpecies.isEmpty {
                    for species in Species.defaultSpecies {
                        modelContext.insert(species)
                    }
                }
            }
        }
    }

    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return !plantName.isEmpty
        case 1:
            return selectedSpecies != nil
        default:
            return true
        }
    }

    private func savePlant() {
        let plant = BambooPlant(
            name: plantName,
            location: location,
            lightLevel: lightLevel,
            container: container,
            species: selectedSpecies,
            photo: photoData,
            notes: notes.isEmpty ? nil : notes
        )

        modelContext.insert(plant)

        // Programar notificación
        NotificationManager.shared.scheduleWateringReminder(for: plant)

        if let onComplete = onComplete {
            onComplete()
        } else {
            dismiss()
        }
    }
}

// MARK: - Step 1: Name

struct NameStep: View {
    @Binding var plantName: String

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "pencil.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.bambooPrimary)

            Text("¿Cómo se llama tu planta?")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 8) {
                Text("Nombre")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                TextField("Ej: Bambú de la oficina", text: $plantName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

// MARK: - Step 2: Species

struct SpeciesStep: View {
    @Binding var selectedSpecies: Species?
    let allSpecies: [Species]

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "leaf.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.bambooPrimary)

            Text("¿Qué tipo de bambú es?")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(allSpecies, id: \.id) { species in
                        SpeciesCard(
                            species: species,
                            isSelected: selectedSpecies?.id == species.id
                        )
                        .onTapGesture {
                            selectedSpecies = species
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
    }
}

struct SpeciesCard: View {
    let species: Species
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(species.commonName)
                        .font(.headline)

                    Text(species.scientificName)
                        .font(.caption)
                        .italic()
                        .foregroundColor(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.bambooPrimary)
                        .font(.title2)
                }
            }

            Text(species.descriptionText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(isSelected ? Color.bambooSecondary : Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.bambooPrimary : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Step 3: Location

struct LocationStep: View {
    @Binding var location: PlantLocation
    @Binding var container: ContainerType

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.bambooPrimary)

            Text("¿Dónde está ubicada?")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            // Ubicación
            VStack(alignment: .leading, spacing: 12) {
                Text("Ubicación")
                    .font(.headline)

                HStack(spacing: 12) {
                    ForEach(PlantLocation.allCases, id: \.self) { loc in
                        SelectionButton(
                            title: loc.description,
                            icon: loc == .interior ? "house.fill" : "sun.max.fill",
                            isSelected: location == loc
                        ) {
                            location = loc
                        }
                    }
                }
            }
            .padding(.horizontal)

            // Contenedor
            VStack(alignment: .leading, spacing: 12) {
                Text("Contenedor")
                    .font(.headline)

                VStack(spacing: 12) {
                    ForEach(ContainerType.allCases, id: \.self) { cont in
                        SelectionButton(
                            title: cont.description,
                            icon: cont.icon,
                            isSelected: container == cont
                        ) {
                            container = cont
                        }
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

// MARK: - Step 4: Light

struct LightStep: View {
    @Binding var lightLevel: LightLevel

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "sun.max.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.bambooPrimary)

            Text("¿Cuánta luz recibe?")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                ForEach(LightLevel.allCases, id: \.self) { light in
                    SelectionButton(
                        title: light.description,
                        icon: light.icon,
                        isSelected: lightLevel == light
                    ) {
                        lightLevel = light
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

// MARK: - Step 5: Photo

struct PhotoStep: View {
    @Binding var selectedPhoto: PhotosPickerItem?
    @Binding var photoData: Data?
    @Binding var notes: String

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "camera.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.bambooPrimary)

            Text("Añade una foto (opcional)")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            // Photo picker
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                if let photoData = photoData,
                   let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.bambooSecondary)
                        .frame(width: 200, height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.largeTitle)
                                Text("Seleccionar Foto")
                                    .font(.caption)
                            }
                            .foregroundColor(.bambooPrimary)
                        )
                }
            }
            .onChange(of: selectedPhoto) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }

            // Notes
            VStack(alignment: .leading, spacing: 8) {
                Text("Notas adicionales (opcional)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                TextEditor(text: $notes)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

// MARK: - Selection Button

struct SelectionButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)

                Text(title)
                    .font(.body)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                }
            }
            .foregroundColor(isSelected ? .bambooPrimary : .primary)
            .padding()
            .background(isSelected ? Color.bambooSecondary : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.bambooPrimary : Color.gray.opacity(0.3), lineWidth: 2)
            )
        }
    }
}

#Preview {
    AddPlantWizardView(isFirstPlant: false)
        .modelContainer(for: [BambooPlant.self, Species.self, CareLog.self])
}

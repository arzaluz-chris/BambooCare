//
//  BambooPlant.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import Foundation
import SwiftData

@Model
final class BambooPlant {
    var id: UUID
    var name: String
    var location: PlantLocation
    var lightLevel: LightLevel
    var container: ContainerType

    var addedDate: Date
    var lastWatered: Date?
    var nextWateringDate: Date?

    // Relación con Species
    var species: Species?

    // Relación con historial de cuidados
    @Relationship(deleteRule: .cascade)
    var careHistory: [CareLog]

    // Foto de la planta (almacenamiento externo para archivos grandes)
    @Attribute(.externalStorage)
    var photo: Data?

    // Notas adicionales del usuario
    var notes: String?

    init(
        name: String,
        location: PlantLocation,
        lightLevel: LightLevel,
        container: ContainerType,
        species: Species? = nil,
        photo: Data? = nil,
        notes: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.location = location
        self.lightLevel = lightLevel
        self.container = container
        self.species = species
        self.photo = photo
        self.notes = notes
        self.addedDate = Date()
        self.lastWatered = nil
        self.nextWateringDate = calculateNextWateringDate()
        self.careHistory = []
    }

    // MARK: - Computed Properties

    var needsWatering: Bool {
        guard let nextWatering = nextWateringDate else { return true }
        return Date() >= nextWatering
    }

    var daysUntilWatering: Int {
        guard let nextWatering = nextWateringDate else { return 0 }
        let days = Calendar.current.dateComponents([.day], from: Date(), to: nextWatering).day ?? 0
        return days
    }

    var wateringStatus: String {
        if needsWatering {
            return "Regar hoy"
        } else {
            let days = daysUntilWatering
            if days == 0 {
                return "Regar hoy"
            } else if days == 1 {
                return "Regar mañana"
            } else {
                return "Regar en \(days) días"
            }
        }
    }

    var wateringStatusColor: String {
        if needsWatering {
            return "red"
        } else if daysUntilWatering <= 1 {
            return "orange"
        } else {
            return "green"
        }
    }

    // MARK: - Methods

    func markAsWatered(date: Date = Date()) {
        lastWatered = date
        nextWateringDate = calculateNextWateringDate()
    }

    func postponeWatering(days: Int) {
        if let next = nextWateringDate {
            nextWateringDate = Calendar.current.date(byAdding: .day, value: days, to: next)
        }
    }

    private func calculateNextWateringDate() -> Date? {
        let baseFrequency = species?.baseWateringFrequencyDays ?? 7

        // Ajustes según ubicación y contenedor
        var adjustedFrequency = baseFrequency

        // Interior vs Exterior
        if location == .interior {
            adjustedFrequency += 1 // Interior necesita menos riego
        }

        // Tipo de contenedor
        switch container {
        case .jarronAgua:
            adjustedFrequency = 7 // Cambiar agua semanalmente
        case .maceta:
            adjustedFrequency -= 1 // Macetas se secan más rápido
        case .suelo:
            adjustedFrequency += 1 // Suelo retiene más humedad
        }

        // Nivel de luz
        switch lightLevel {
        case .directa:
            adjustedFrequency -= 1 // Más luz = más evaporación
        case .sombra:
            adjustedFrequency += 1 // Menos luz = menos evaporación
        case .indirecta:
            break // Sin ajuste
        }

        // Asegurar que sea al menos 1 día
        adjustedFrequency = max(adjustedFrequency, 1)

        let startDate = lastWatered ?? addedDate
        return Calendar.current.date(byAdding: .day, value: adjustedFrequency, to: startDate)
    }

    func addCareLog(_ log: CareLog) {
        careHistory.append(log)

        // Si es un riego, actualizar fechas
        if log.type == .riego {
            markAsWatered(date: log.date)
        }
    }
}

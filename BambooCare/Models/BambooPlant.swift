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

    var species: Species?

    @Relationship(deleteRule: .cascade)
    var careHistory: [CareLog] = []

    @Attribute(.externalStorage)
    var photoData: Data?

    init(name: String, location: PlantLocation, lightLevel: LightLevel, container: ContainerType) {
        self.id = UUID()
        self.name = name
        self.location = location
        self.lightLevel = lightLevel
        self.container = container
        self.addedDate = Date()
        self.lastWatered = nil
    }

    // Computed property for next watering date
    var nextWateringDate: Date? {
        guard let lastWatered = lastWatered,
              let species = species else {
            return nil
        }

        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: species.baseWateringFrequencyDays, to: lastWatered)
    }

    // Computed property for watering status
    var wateringStatus: String {
        guard let nextWatering = nextWateringDate else {
            return "Regar hoy"
        }

        let calendar = Calendar.current
        let now = Date()

        if nextWatering <= now {
            return "Regar hoy"
        } else {
            let components = calendar.dateComponents([.day], from: now, to: nextWatering)
            if let days = components.day {
                return days == 1 ? "Regar en 1 día" : "Regar en \(days) días"
            }
        }

        return "Regado"
    }
}

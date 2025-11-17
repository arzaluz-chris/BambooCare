//
//  Species.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import Foundation
import SwiftData

@Model
final class Species {
    var id: UUID
    var commonName: String
    var scientificName: String
    var descriptionText: String
    var baseWateringFrequencyDays: Int
    var waterAmountGuide: String

    // Relación inversa
    @Relationship(inverse: \BambooPlant.species)
    var plants: [BambooPlant]?

    init(
        commonName: String,
        scientificName: String,
        descriptionText: String,
        baseWateringFrequencyDays: Int,
        waterAmountGuide: String
    ) {
        self.id = UUID()
        self.commonName = commonName
        self.scientificName = scientificName
        self.descriptionText = descriptionText
        self.baseWateringFrequencyDays = baseWateringFrequencyDays
        self.waterAmountGuide = waterAmountGuide
    }

    // Especies predeterminadas
    static var defaultSpecies: [Species] {
        return [
            Species(
                commonName: "Bambú de la Suerte",
                scientificName: "Dracaena sanderiana",
                descriptionText: "No es un bambú verdadero, sino una dracena. Popular como planta de interior, crece en agua o tierra.",
                baseWateringFrequencyDays: 7,
                waterAmountGuide: "Cambia el agua semanalmente si está en jarrón. Si está en tierra, mantén húmeda pero no encharcada."
            ),
            Species(
                commonName: "Bambú Dorado",
                scientificName: "Phyllostachys aurea",
                descriptionText: "Bambú verdadero con cañas amarillas doradas. Crece bien en exteriores.",
                baseWateringFrequencyDays: 3,
                waterAmountGuide: "Riego abundante, especialmente en verano. La tierra debe estar siempre húmeda."
            ),
            Species(
                commonName: "Bambú Negro",
                scientificName: "Phyllostachys nigra",
                descriptionText: "Bambú con cañas que se tornan negras con la madurez. Muy ornamental.",
                baseWateringFrequencyDays: 3,
                waterAmountGuide: "Mantén el suelo húmedo. Riega más frecuentemente en clima cálido."
            ),
            Species(
                commonName: "Fargesia",
                scientificName: "Fargesia murielae",
                descriptionText: "Bambú no invasivo, perfecto para jardines pequeños. Tolera el frío.",
                baseWateringFrequencyDays: 4,
                waterAmountGuide: "Riego moderado. La tierra debe estar húmeda pero bien drenada."
            ),
            Species(
                commonName: "Bambusa",
                scientificName: "Bambusa vulgaris",
                descriptionText: "Bambú común tropical, de crecimiento rápido y gran altura.",
                baseWateringFrequencyDays: 2,
                waterAmountGuide: "Requiere riego abundante y frecuente, especialmente en climas cálidos."
            ),
            Species(
                commonName: "Bambú Paraguas",
                scientificName: "Fargesia robusta",
                descriptionText: "Bambú compacto con hojas densas, ideal para setos y pantallas.",
                baseWateringFrequencyDays: 4,
                waterAmountGuide: "Riego regular, mantén la tierra constantemente húmeda."
            )
        ]
    }
}

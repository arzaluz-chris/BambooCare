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

    @Relationship(deleteRule: .nullify, inverse: \BambooPlant.species)
    var plants: [BambooPlant] = []

    init(commonName: String, scientificName: String, descriptionText: String, baseWateringFrequencyDays: Int, waterAmountGuide: String) {
        self.id = UUID()
        self.commonName = commonName
        self.scientificName = scientificName
        self.descriptionText = descriptionText
        self.baseWateringFrequencyDays = baseWateringFrequencyDays
        self.waterAmountGuide = waterAmountGuide
    }
}

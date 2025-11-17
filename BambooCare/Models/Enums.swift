//
//  Enums.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import Foundation

enum PlantLocation: String, Codable, CaseIterable {
    case interior = "Interior"
    case exterior = "Exterior"
}

enum LightLevel: String, Codable, CaseIterable {
    case direct = "Luz Directa"
    case indirect = "Luz Indirecta"
    case shade = "Sombra"
}

enum ContainerType: String, Codable, CaseIterable {
    case pot = "Maceta"
    case ground = "Suelo"
    case waterVase = "Jarrón de Agua"
}

enum CareType: String, Codable, CaseIterable {
    case watering = "Riego"
    case fertilizer = "Fertilizante"
    case pruning = "Poda"
    case photo = "Foto"
}

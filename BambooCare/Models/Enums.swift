//
//  Enums.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import Foundation

// MARK: - PlantLocation
enum PlantLocation: String, Codable, CaseIterable {
    case interior = "Interior"
    case exterior = "Exterior"

    var description: String {
        return rawValue
    }
}

// MARK: - LightLevel
enum LightLevel: String, Codable, CaseIterable {
    case directa = "Luz Directa"
    case indirecta = "Luz Indirecta"
    case sombra = "Sombra"

    var description: String {
        return rawValue
    }

    var icon: String {
        switch self {
        case .directa:
            return "sun.max.fill"
        case .indirecta:
            return "sun.min.fill"
        case .sombra:
            return "cloud.fill"
        }
    }
}

// MARK: - ContainerType
enum ContainerType: String, Codable, CaseIterable {
    case maceta = "Maceta"
    case suelo = "Suelo"
    case jarronAgua = "Jarrón con Agua"

    var description: String {
        return rawValue
    }

    var icon: String {
        switch self {
        case .maceta:
            return "cylinder.fill"
        case .suelo:
            return "leaf.fill"
        case .jarronAgua:
            return "drop.fill"
        }
    }
}

// MARK: - CareType
enum CareType: String, Codable, CaseIterable {
    case riego = "Riego"
    case fertilizante = "Fertilizante"
    case poda = "Poda"
    case transplante = "Transplante"
    case observacion = "Observación"

    var description: String {
        return rawValue
    }

    var icon: String {
        switch self {
        case .riego:
            return "drop.fill"
        case .fertilizante:
            return "leaf.circle.fill"
        case .poda:
            return "scissors"
        case .transplante:
            return "arrow.triangle.2.circlepath"
        case .observacion:
            return "eye.fill"
        }
    }

    var color: String {
        switch self {
        case .riego:
            return "blue"
        case .fertilizante:
            return "green"
        case .poda:
            return "orange"
        case .transplante:
            return "purple"
        case .observacion:
            return "gray"
        }
    }
}

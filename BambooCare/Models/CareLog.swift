//
//  CareLog.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import Foundation
import SwiftData

@Model
final class CareLog {
    var id: UUID
    var date: Date
    var type: CareType
    var notes: String

    // Relación con la planta
    var plant: BambooPlant?

    init(date: Date = Date(), type: CareType, notes: String = "") {
        self.id = UUID()
        self.date = date
        self.type = type
        self.notes = notes
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }

    var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

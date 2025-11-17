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

    var plant: BambooPlant?

    init(date: Date, type: CareType, notes: String) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.notes = notes
    }
}

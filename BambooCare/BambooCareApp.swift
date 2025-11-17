//
//  BambooCareApp.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI
import SwiftData

@main
struct BambooCareApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BambooPlant.self,
            Species.self,
            CareLog.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

//
//  ContentView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [BambooPlant.self, Species.self, CareLog.self])
}

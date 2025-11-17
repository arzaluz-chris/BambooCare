//
//  MainTabView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Mis Bambús (Dashboard)
            DashboardView()
                .tabItem {
                    Label("Mis Bambús", systemImage: "leaf.fill")
                }
                .tag(0)

            // Tab 2: Guía de Cuidados
            CareGuideView()
                .tabItem {
                    Label("Guía", systemImage: "book.fill")
                }
                .tag(1)

            // Tab 3: Ajustes
            SettingsView()
                .tabItem {
                    Label("Ajustes", systemImage: "gear")
                }
                .tag(2)
        }
        .tint(.bambooPrimary)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [BambooPlant.self, Species.self, CareLog.self])
}

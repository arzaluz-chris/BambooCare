//
//  MainTabView.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Mis Bambús", systemImage: "leaf.fill")
                }
                .tag(0)

            CareGuideView()
                .tabItem {
                    Label("Guía", systemImage: "book.fill")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Ajustes", systemImage: "gearshape.fill")
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

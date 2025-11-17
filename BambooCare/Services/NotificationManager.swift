//
//  NotificationManager.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import Foundation
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private init() {
        Task {
            await checkAuthorizationStatus()
        }
    }

    func requestAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await checkAuthorizationStatus()
        } catch {
            print("Notification permission error: \(error.localizedDescription)")
        }
    }

    func checkAuthorizationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    func scheduleWateringReminder(for plant: BambooPlant) {
        guard let nextWatering = plant.nextWateringDate else { return }

        let content = UNMutableNotificationContent()
        content.title = "¡Hora de regar!"
        content.body = "Es momento de regar tu '\(plant.name)'"
        content.sound = .default
        content.categoryIdentifier = "WATERING_REMINDER"

        // Schedule notification
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextWatering)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: "watering-\(plant.id.uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            }
        }
    }

    func cancelWateringReminder(for plant: BambooPlant) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["watering-\(plant.id.uuidString)"]
        )
    }

    func rescheduleAllReminders(for plants: [BambooPlant]) {
        // Cancel all existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        // Reschedule for all plants
        for plant in plants {
            scheduleWateringReminder(for: plant)
        }
    }
}

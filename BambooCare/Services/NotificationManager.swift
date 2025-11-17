//
//  NotificationManager.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import Foundation
import UserNotifications
import SwiftUI

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private init() {
        Task {
            await checkAuthorizationStatus()
        }
    }

    // MARK: - Authorization

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            await checkAuthorizationStatus()
            return granted
        } catch {
            print("Error requesting notification authorization: \(error)")
            return false
        }
    }

    func checkAuthorizationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    // MARK: - Schedule Notifications

    func scheduleWateringReminder(for plant: BambooPlant) {
        guard let nextWatering = plant.nextWateringDate else { return }

        // Cancelar notificación existente
        cancelWateringReminder(for: plant)

        // Crear contenido de la notificación
        let content = UNMutableNotificationContent()
        content.title = "🌿 Hora de regar"
        content.body = "Es momento de regar tu \(plant.name)"
        content.sound = .default
        content.categoryIdentifier = "WATERING_REMINDER"
        content.userInfo = ["plantId": plant.id.uuidString]

        // Configurar trigger para la fecha de riego
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nextWatering)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        // Crear request
        let request = UNNotificationRequest(
            identifier: "watering-\(plant.id.uuidString)",
            content: content,
            trigger: trigger
        )

        // Agregar notificación
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func cancelWateringReminder(for plant: BambooPlant) {
        let identifier = "watering-\(plant.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func scheduleAllWateringReminders(for plants: [BambooPlant]) {
        for plant in plants {
            scheduleWateringReminder(for: plant)
        }
    }

    func cancelAllWateringReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - Weather Alerts

    func scheduleWeatherAlert(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = "🌦️ \(title)"
        content.body = message
        content.sound = .default
        content.categoryIdentifier = "WEATHER_ALERT"

        // Trigger inmediato
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(
            identifier: "weather-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Care Reminders

    func scheduleCareReminder(title: String, message: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        content.categoryIdentifier = "CARE_REMINDER"

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: "care-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}

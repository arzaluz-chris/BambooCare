//
//  WeatherService.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import Foundation
import WeatherKit
import CoreLocation
import SwiftUI

@MainActor
class WeatherService: ObservableObject {
    static let shared = WeatherService()

    private let weatherService = WeatherKit.WeatherService.shared

    @Published var currentWeather: CurrentWeather?
    @Published var dailyForecast: [DayWeather]?
    @Published var isLoading = false
    @Published var error: String?

    private init() {}

    // MARK: - Fetch Weather

    func fetchWeather(for location: CLLocation) async {
        isLoading = true
        error = nil

        do {
            let weather = try await weatherService.weather(for: location)

            currentWeather = weather.currentWeather
            dailyForecast = Array(weather.dailyForecast.prefix(7))

            isLoading = false
        } catch {
            self.error = "Error obteniendo clima: \(error.localizedDescription)"
            isLoading = false
        }
    }

    // MARK: - Weather Analysis for Watering

    func shouldAdjustWatering(for location: CLLocation) async -> WateringAdjustment {
        do {
            let weather = try await weatherService.weather(for: location)

            var adjustment = WateringAdjustment.normal
            var reason = ""

            // Verificar lluvia reciente (últimos 2 días)
            let recentRain = hasRecentPrecipitation(weather.dailyForecast)
            if recentRain {
                adjustment = .postpone
                reason = "Ha llovido recientemente"
                return WateringAdjustment(type: adjustment, reason: reason)
            }

            // Verificar pronóstico de lluvia
            let rainComing = willRainSoon(weather.dailyForecast)
            if rainComing {
                adjustment = .postpone
                reason = "Se espera lluvia pronto"
                return WateringAdjustment(type: adjustment, reason: reason)
            }

            // Verificar temperatura alta
            if let temp = weather.currentWeather.temperature.value,
               temp > 30 {
                adjustment = .increase
                reason = "Temperatura alta (\(Int(temp))°C)"
                return WateringAdjustment(type: adjustment, reason: reason)
            }

            // Verificar humedad baja
            if weather.currentWeather.humidity < 0.3 {
                adjustment = .increase
                reason = "Humedad baja (\(Int(weather.currentWeather.humidity * 100))%)"
                return WateringAdjustment(type: adjustment, reason: reason)
            }

            return WateringAdjustment(type: .normal, reason: "Condiciones normales")

        } catch {
            print("Error analyzing weather: \(error)")
            return WateringAdjustment(type: .normal, reason: "No se pudo obtener información del clima")
        }
    }

    // MARK: - Helper Methods

    private func hasRecentPrecipitation(_ forecast: Forecast<DayWeather>) -> Bool {
        let last2Days = Array(forecast.prefix(2))
        return last2Days.contains { day in
            if let precipitation = day.precipitationAmount.value {
                return precipitation > 5.0 // 5mm de lluvia
            }
            return false
        }
    }

    private func willRainSoon(_ forecast: Forecast<DayWeather>) -> Bool {
        let next2Days = Array(forecast.prefix(2))
        return next2Days.contains { day in
            day.precipitationChance > 0.7 // 70% de probabilidad
        }
    }

    // MARK: - Weather Alerts

    func checkForWeatherAlerts(for location: CLLocation) async -> [String] {
        do {
            let weather = try await weatherService.weather(for: location)
            var alerts: [String] = []

            // Ola de calor
            if let temp = weather.currentWeather.temperature.value,
               temp > 35 {
                alerts.append("Ola de calor: Asegúrate de regar tus plantas de exterior.")
            }

            // Helada
            let forecast = Array(weather.dailyForecast.prefix(3))
            if forecast.contains(where: { $0.lowTemperature.value < 0 }) {
                alerts.append("Alerta de helada: Protege tus plantas sensibles al frío.")
            }

            // Tormenta fuerte
            if weather.currentWeather.condition == .tropicalStorm ||
               weather.currentWeather.condition == .hurricane {
                alerts.append("Tormenta fuerte: Protege tus plantas de exterior.")
            }

            return alerts
        } catch {
            print("Error checking weather alerts: \(error)")
            return []
        }
    }

    // MARK: - Weather Summary

    func getWeatherSummary() -> String {
        guard let current = currentWeather else {
            return "Clima no disponible"
        }

        let temp = Int(current.temperature.value)
        let condition = current.condition.description
        let humidity = Int(current.humidity * 100)

        return "\(condition), \(temp)°C, Humedad: \(humidity)%"
    }
}

// MARK: - Supporting Types

enum WateringAdjustmentType {
    case increase      // Regar más frecuentemente
    case postpone      // Posponer riego
    case normal        // Sin cambios
}

struct WateringAdjustment {
    let type: WateringAdjustmentType
    let reason: String
}

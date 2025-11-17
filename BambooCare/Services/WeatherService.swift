//
//  WeatherService.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import Foundation
import WeatherKit
import CoreLocation

@MainActor
class WeatherService: ObservableObject {
    private let service = WeatherKit.WeatherService.shared

    @Published var currentWeather: CurrentWeather?
    @Published var dailyForecast: [DayWeather] = []

    func fetchWeather(for location: CLLocation) async {
        do {
            let weather = try await service.weather(for: location)

            currentWeather = weather.currentWeather
            dailyForecast = Array(weather.dailyForecast.prefix(7))
        } catch {
            print("Weather fetch error: \(error.localizedDescription)")
        }
    }

    // Calculate if watering should be adjusted based on weather
    func shouldAdjustWatering(baseFrequencyDays: Int, isOutdoor: Bool) -> WateringAdjustment {
        guard isOutdoor, let current = currentWeather else {
            return .none
        }

        // Check for recent precipitation
        if current.precipitationAmount.value > 5.0 { // More than 5mm of rain
            return .postpone(days: 2)
        }

        // Check humidity
        if current.humidity > 0.8 { // High humidity
            return .postpone(days: 1)
        }

        // Check for heat wave
        if current.temperature.value > 35.0 { // Above 35°C
            return .accelerate(days: 1)
        }

        // Check wind (high evaporation)
        if current.wind.speed.value > 30.0 { // Strong wind
            return .accelerate(days: 1)
        }

        return .none
    }
}

enum WateringAdjustment {
    case none
    case postpone(days: Int)
    case accelerate(days: Int)
}

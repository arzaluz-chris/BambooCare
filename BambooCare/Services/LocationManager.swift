//
//  LocationManager.swift
//  BambooCare
//
//  Created by Christian Arzaluz on 17/11/25.
//

import Foundation
import CoreLocation
import SwiftUI

@MainActor
class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?
    @Published var isUpdatingLocation = false
    @Published var locationError: String?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = locationManager.authorizationStatus
    }

    // MARK: - Authorization

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    var isAuthorized: Bool {
        return authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    // MARK: - Location Updates

    func requestLocation() {
        guard isAuthorized else {
            locationError = "Permiso de ubicación no concedido"
            return
        }

        isUpdatingLocation = true
        locationError = nil
        locationManager.requestLocation()
    }

    func startUpdatingLocation() {
        guard isAuthorized else {
            locationError = "Permiso de ubicación no concedido"
            return
        }

        isUpdatingLocation = true
        locationError = nil
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        isUpdatingLocation = false
    }

    // MARK: - Geocoding

    func getCityName(for location: CLLocation) async -> String? {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            return placemarks.first?.locality
        } catch {
            print("Geocoding error: \(error)")
            return nil
        }
    }

    func getCoordinates(for cityName: String) async -> CLLocation? {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.geocodeAddressString(cityName)
            if let location = placemarks.first?.location {
                return location
            }
        } catch {
            print("Geocoding error: \(error)")
        }
        return nil
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            guard let location = locations.last else { return }
            currentLocation = location
            isUpdatingLocation = false
            stopUpdatingLocation()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            locationError = error.localizedDescription
            isUpdatingLocation = false
        }
    }
}

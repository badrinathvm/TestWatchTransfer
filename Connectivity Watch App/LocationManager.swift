//
//  LocationManager.swift
//  Connectivity Watch App
//
//  Created by Rani Badri on 10/19/25.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    @Published var locationName: String?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
    }

    func requestLocationPermission() {
        print("📍 LocationManager: Requesting location permission...")
        print("📍 LocationManager: Current status before request: \(authorizationStatus.rawValue)")
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            print("⚠️ Location permission not granted")
            return
        }

        locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        print("📍 Location authorization status: \(authorizationStatus.rawValue)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        print("📍 Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")

        // Reverse geocode to get location name
        reverseGeocodeLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error.localizedDescription)")
    }

    private func reverseGeocodeLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("❌ Reverse geocoding error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                // Format location name
                var components: [String] = []

                if let name = placemark.name {
                    components.append(name)
                } else if let thoroughfare = placemark.thoroughfare {
                    components.append(thoroughfare)
                }

                if let locality = placemark.locality {
                    components.append(locality)
                }

                if let administrativeArea = placemark.administrativeArea {
                    components.append(administrativeArea)
                }

                self?.locationName = components.isEmpty ? "Unknown Location" : components.joined(separator: ", ")
                print("📍 Location name: \(self?.locationName ?? "Unknown")")
            }
        }
    }
}

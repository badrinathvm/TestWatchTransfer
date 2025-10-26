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
    @Published var isGeocodingInProgress: Bool = false

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

        print("📍 Requesting fresh location...")
        locationManager.requestLocation()
    }

    func clearLocation() {
        print("📍 Clearing cached location")
        currentLocation = nil
        locationName = nil
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        print("📍 Location authorization status: \(authorizationStatus.rawValue)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("📍 ========== didUpdateLocations called ==========")
        print("📍 Locations received: \(locations.count)")

        guard let location = locations.last else {
            print("❌ No location in locations array")
            return
        }

        currentLocation = location
        print("📍 Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        print("📍 Location accuracy: \(location.horizontalAccuracy)m")
        print("📍 Location timestamp: \(location.timestamp)")

        // Check if this is a valid location
        if location.horizontalAccuracy < 0 {
            print("⚠️ Invalid location accuracy - may be stale")
        }

        // Reverse geocode to get location name
        print("📍 About to call reverseGeocodeLocation...")
        reverseGeocodeLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error.localizedDescription)")
    }

    private func reverseGeocodeLocation(_ location: CLLocation) {
        print("📍 ========== Starting reverse geocoding ==========")
        print("📍 Coordinates: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        print("📍 Timestamp: \(location.timestamp)")

        isGeocodingInProgress = true

        let geocoder = CLGeocoder()
        print("📍 CLGeocoder created, calling reverseGeocodeLocation...")

        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            print("📍 ========== Geocoding callback received ==========")
            defer {
                self?.isGeocodingInProgress = false
                print("📍 Reverse geocoding completed")
            }

            // Check for error first
            if let error = error {
                print("❌ Reverse geocoding error: \(error.localizedDescription)")
                print("❌ Error code: \(error)")
                // Use coordinates as fallback
                self?.locationName = String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
                print("📍 Using coordinates as location name due to error")
                return
            }

            // Check if placemarks array exists and has items
            print("📍 Placemarks count: \(placemarks?.count ?? 0)")

            guard let placemark = placemarks?.first else {
                print("❌ No placemark found in response")
                self?.locationName = String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
                print("📍 Using coordinates as location name (no placemark)")
                return
            }

            // We have a placemark, print all details
            print("📍 ========== Placemark Found ==========")
            if let placemark = placemarks?.first {
                // Debug: Print all placemark components
                print("📍 Placemark details:")
                print("  - name: \(placemark.name ?? "nil")")
                print("  - thoroughfare: \(placemark.thoroughfare ?? "nil")")
                print("  - subThoroughfare: \(placemark.subThoroughfare ?? "nil")")
                print("  - locality: \(placemark.locality ?? "nil")")
                print("  - subLocality: \(placemark.subLocality ?? "nil")")
                print("  - administrativeArea: \(placemark.administrativeArea ?? "nil")")
                print("  - subAdministrativeArea: \(placemark.subAdministrativeArea ?? "nil")")
                print("  - country: \(placemark.country ?? "nil")")
                print("  - postalCode: \(placemark.postalCode ?? "nil")")

                // Format location name with priority order
                var components: [String] = []

                // Priority 1: Try subLocality (neighborhood) or locality (city)
                if let subLocality = placemark.subLocality {
                    components.append(subLocality)
                } else if let locality = placemark.locality {
                    components.append(locality)
                }

                // Priority 2: Add state/province
                if let administrativeArea = placemark.administrativeArea {
                    components.append(administrativeArea)
                }

                // Priority 3: If nothing yet, try thoroughfare (street)
                if components.isEmpty, let thoroughfare = placemark.thoroughfare {
                    components.append(thoroughfare)
                }

                // Priority 4: If still nothing, use country
                if components.isEmpty, let country = placemark.country {
                    components.append(country)
                }

                // Fallback to coordinates if all else fails
                let formattedName: String
                if components.isEmpty {
                    formattedName = String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
                    print("⚠️ Using coordinates as location name")
                } else {
                    formattedName = components.joined(separator: ", ")
                }

                self?.locationName = formattedName
                print("📍 ========== Location name updated: \(formattedName) ==========")
            }

            // This else should never be reached due to guard above, but keep for safety
            // else {
            //     print("❌ No placemark found")
            //     self?.locationName = String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude)
            // }
        }
    }
}

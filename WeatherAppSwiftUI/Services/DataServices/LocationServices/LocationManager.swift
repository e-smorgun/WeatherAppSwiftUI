//
//  LacationService.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 8.12.23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        locationManager.startUpdatingLocation()

        locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate
    func checkLocationPermission() -> Bool {
       switch CLLocationManager.authorizationStatus() {
           case .authorizedWhenInUse, .authorizedAlways:
               return true
           default:
               return false
       }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        currentLocation = newLocation
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Обработка ошибок получения местоположения
        print("Ошибка получения местоположения: \(error.localizedDescription)")
    }
}


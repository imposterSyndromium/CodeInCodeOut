//
//  AppStateManager.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-09-22.
//


import SwiftUI
import CoreLocation

class AppStateManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        checkLocationAuthorization()
    }

    func checkLocationAuthorization() {
        locationAuthorizationStatus = locationManager.authorizationStatus
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorizationStatus = manager.authorizationStatus
    }
}

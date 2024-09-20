//
//  LocationFetcher.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-15.
//

import CoreLocation

// This struct is a solution to make CLLocationCoorinate2D able to be saved as Data (must conform to Codable), so it can be converted to JSON and saved in SwiftData.
struct CoordinateData: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var locationCompletion: ((Data?) -> Void)?
    private var timeoutTimer: Timer?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getLocation(timeout: TimeInterval = 10, completion: @escaping (Data?) -> Void) {
        locationCompletion = completion
        manager.startUpdatingLocation()
        
        // Set a timeout
        timeoutTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { [weak self] _ in
            self?.timeoutLocation()
        }
    }
    
    private func timeoutLocation() {
        manager.stopUpdatingLocation()
        locationCompletion?(nil)
        locationCompletion = nil
        timeoutTimer?.invalidate()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let coordinateData = CoordinateData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        do {
            let data = try JSONEncoder().encode(coordinateData)
            print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            manager.stopUpdatingLocation()
            locationCompletion?(data)
        } catch {
            print("Failed to encode location: \(error.localizedDescription)")
            locationCompletion?(nil)
        }
        
        locationCompletion = nil
        timeoutTimer?.invalidate()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
        locationCompletion?(nil)
        locationCompletion = nil
        timeoutTimer?.invalidate()
    }
}


//example usage:
//struct ContentView: View {
//    let locationFetcher = LocationFetcher()
//
//    var body: some View {
//        VStack {
//            Button("Start Tracking Location") {
//                locationFetcher.start()
//            }
//
//            Button("Read Location") {
//                if let location = locationFetcher.lastKnownLocation {
//                    print("Your location is \(location)")
//                } else {
//                    print("Your location is unknown")
//                }
//            }
//        }
//    }
//}

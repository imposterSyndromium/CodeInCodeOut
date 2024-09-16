//
//  LocationFetcher.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-15.
//

import CoreLocation

// This struct is a solution to make CLLocationCoorinate2D able to be saved as Data (must conform to Codable), so it can be converted to JSON and saved in SwiftData.
struct CoordinateData: Codable {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
}


class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        print("from locationFetcher: got location coordinates! \(String(describing: lastKnownLocation))")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location manager errors here
        print("from locationFetcher - Location manager error: \(error.localizedDescription)")
    }
    
    func getLocation() -> Data? {
        //locationFetcher.start()
        start()
        
        if let fetchedLocation = lastKnownLocation { //locationFetcher.lastKnownLocation {
            
            let coordinateData = CoordinateData(latitude: fetchedLocation.latitude, longitude: fetchedLocation.longitude)
            
            if let data = try? JSONEncoder().encode(coordinateData) {
                print("location: \(data)")
                return data
            }
        }
        return nil
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

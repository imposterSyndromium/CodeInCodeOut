//
//  MapTools.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-10-04.
//

import Foundation
import MapKit



func decodeMapLocation(mapLocationData: Data) -> CLLocationCoordinate2D? {
    if let decodedCoordinateData = try? JSONDecoder().decode(CoordinateData.self, from: mapLocationData) {
        let coordinate = CLLocationCoordinate2D(latitude: decodedCoordinateData.latitude, longitude: decodedCoordinateData.longitude)
        print("Mapview - JSON Decoded Coordinate: \(coordinate)")
        
        return coordinate
    }
    
    print("unable to decode map location from JSON")
    return nil
}




func calculateRegion(for locations: [CLLocationCoordinate2D], withPadding padding: Double = 1.1) -> MKCoordinateRegion {
    guard !locations.isEmpty else {
        // Default to a region centered on a neutral location if no pins exist
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                  span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
    }
    
    let minLat = locations.map { $0.latitude }.min()!
    let maxLat = locations.map { $0.latitude }.max()!
    let minLon = locations.map { $0.longitude }.min()!
    let maxLon = locations.map { $0.longitude }.max()!
    
    let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                        longitude: (minLon + maxLon) / 2)
    
    let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * padding,
                                longitudeDelta: (maxLon - minLon) * padding)
    
    return MKCoordinateRegion(center: center, span: span)
}


func regionForLastLocation(_ coordinate: CLLocationCoordinate2D, latitudeDelta: CLLocationDegrees = 0.05, longitudeDelta: CLLocationDegrees = 0.05) -> MKCoordinateRegion {
    MKCoordinateRegion(center: coordinate,
                       span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
}

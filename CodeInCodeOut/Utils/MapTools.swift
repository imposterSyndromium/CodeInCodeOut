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


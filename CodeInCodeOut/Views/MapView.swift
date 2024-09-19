//
//  MapView.swift
//  iRemember
//
//  Created by Robin O'Brien on 2024-02-29.
//
import MapKit
import SwiftUI


struct MapView: View {
    
    @State private var mapCameraPosition: MapCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    
    @State var locationData: Data?
    @State var locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    
    var body: some View {
        VStack {
            
            Map(position: $mapCameraPosition) {
                Annotation("Scanned Here1", coordinate: locationCoordinate) {

                    Image(systemName: "star.circle")
                        .resizable()
                        .foregroundStyle(.red)
                        .frame(width: 44, height: 44)
                        .background(.white)
                        .clipShape(.circle)
                    
                    Text("Scanned Here2")
                        .padding(.horizontal)
                        .background(.red.gradient)
                        .foregroundColor(.white)
                        .clipShape(.capsule)
                }
                .annotationTitles(.hidden)
            }
            .mapStyle(.hybrid)
                
        }
        .toolbar {
            ToolbarItem {
                Button("Back") {
                    
                }
            }
        }
        .onAppear {
            if let location = locationData {
                if let decodedLocation = decodeMapLocation(mapLocationData: location) {
                    locationCoordinate = decodedLocation
                    updateMapPosition(location: decodedLocation)
                }
            }
        }
    }
    
    
    
    func updateMapPosition(location: CLLocationCoordinate2D) {
        mapCameraPosition = MapCameraPosition.region(
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        )
    }
    
    
    func decodeMapLocation(mapLocationData: Data) -> CLLocationCoordinate2D? {
        if let decodedCoordinateData = try? JSONDecoder().decode(CoordinateData.self, from: mapLocationData) {
            let coordinate = CLLocationCoordinate2D(latitude: decodedCoordinateData.latitude, longitude: decodedCoordinateData.longitude)
            print("Decoded Coordinate: \(coordinate)")
            
            return coordinate
        }
        
        print("unable to decode map location")
        return nil
    }
}



#Preview {

    return MapView()
}

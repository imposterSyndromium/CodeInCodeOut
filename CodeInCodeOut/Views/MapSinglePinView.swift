//
//  MapView.swift
//  iRemember
//
//  Created by Robin O'Brien on 2024-09-19
//
import MapKit
import SwiftUI


struct MapSinglePinView: View {
    
    @State var locationData: Data?
    let isInteractionDisabled: Bool
    @State private var locationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    // initial map position - this gets updated in .onAppear
    @State private var mapCameraPosition: MapCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.728, longitude: -80.950),
                           span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    
    
    var body: some View {
        VStack {
            
            Map(position: $mapCameraPosition, interactionModes: isInteractionDisabled ? [] : .all) {
                Annotation("Scanned Here", coordinate: locationCoordinate) {
                    VStack {
                        Image(systemName: "mappin")
                            .padding(4)
                            .background(Color.white.opacity(0.75))
                            .clipShape(Circle())
                            .foregroundStyle(.red)
                        
                        Text("Scanned Here")
                            .font(.callout)
                            .foregroundColor(.red)
                            .padding(6)
                            .background(Color.white.opacity(0.75))
                            //.cornerRadius(4)
                            .clipShape(.capsule)
                    }
                }
                .annotationTitles(.hidden)
                
                
            }
            .mapStyle(.hybrid)
            
        }
        .onAppear {
            // get and decode the location data (from JSON -> Data? ->  CLLocationCoordinate2D)
            if let location = locationData,
               let decodedLocation = decodeMapLocation(mapLocationData: location) {
                locationCoordinate = decodedLocation
                updateMapPosition(location: decodedLocation)
                
            }
        }
    }
    
    
    
    
    
    func updateMapPosition(location: CLLocationCoordinate2D) {
        mapCameraPosition = MapCameraPosition.region(
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        )
    }
    
 
}



#Preview {
    MapSinglePinView(isInteractionDisabled: false)
}

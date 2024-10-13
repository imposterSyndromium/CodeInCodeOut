//
//  MapMultiPinArrayView.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-10-04.
//


/// This code is a combination of me writing a view, and asking AI to enhance its capabilities.  AI did the clusters, initial location, popup menu.
import MapKit
import SwiftData
import SwiftUI

struct MapMultiPinArrayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CodeScanData.dateAdded, order: .reverse) private var scans: [CodeScanData]
    
    @State private var selectedCluster: ScanCluster?
    @State private var selectedScan: CodeScanData?
    
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    @State private var popupPosition: CGPoint?
    
    @State private var showDebugText: Bool = false
    @State private var debugText: String = ""

    var body: some View {
        ZStack {
            if scans.isEmpty {
                ContentUnavailableView("No scans yet!", systemImage: "qrcode.viewfinder", description: Text("There are no scanned codes yet. Press to scan a code with your camera to start"))
            } else if hasValidLocations() {
                MapReader { proxy in
                    Map(position: $mapCameraPosition, selection: $selectedCluster) {
                        ForEach(createClusters()) { cluster in
                            Annotation(cluster.title, coordinate: cluster.coordinate) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                                    .onTapGesture {
                                        selectedCluster = cluster
                                        updatePopupPosition(for: cluster, using: proxy)
                                    }
                            }
                            .tag(cluster)
                        }
                    }
                    .onAppear(perform: setInitialCameraPosition)
                }
                
                if let _ = selectedCluster, let position = popupPosition {
                    ClusterPopupView(cluster: selectedCluster!, selectedScan: $selectedScan, onClose: {
                        selectedCluster = nil
                        popupPosition = nil
                    })
                    .position(position)
                    .transition(.scale)
                }

                // Debug overlay
                if showDebugText {
                    VStack {
                        Text(debugText)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        Spacer()
                    }
                }
                
            } else {
                ContentUnavailableView("Locations not available", systemImage: "location.slash", description: Text("There is no location history for any scans. To enable future scan location availability, go to Settings > Privacy & Security > Location Services > CodeInCodeOut"))
            }
        }
    }
    
    private func hasValidLocations() -> Bool {
        scans.contains { scan in
            guard let location = scan.location else { return false }
            return decodeMapLocation(mapLocationData: location) != nil
        }
    }
    
    private func createClusters() -> [ScanCluster] {
        let validScans = scans.compactMap { scan -> (CodeScanData, CLLocationCoordinate2D)? in
            guard let location = scan.location,
                  let coordinate = decodeMapLocation(mapLocationData: location) else {
                return nil
            }
            return (scan, coordinate)
        }
        
        var clusters: [ScanCluster] = []
        let clusteringDistance: CLLocationDistance = 250 // 250 meters
        
        for (scan, coordinate) in validScans {
            if let existingClusterIndex = clusters.firstIndex(where: { $0.coordinate.distance(to: coordinate) <= clusteringDistance }) {
                clusters[existingClusterIndex].scans.append(scan)
            } else {
                clusters.append(ScanCluster(coordinate: coordinate, scans: [scan]))
            }
        }
        
        return clusters
    }
    
    private func setInitialCameraPosition() {
        // get last scan, and second last scan coordinates
        guard let lastScanLocation = scans.first?.location,
              let lastCoordinate = decodeMapLocation(mapLocationData: lastScanLocation),
              let secondLastScanLocation = scans.dropFirst().first?.location,
              let secondLastCoordinate = decodeMapLocation(mapLocationData: secondLastScanLocation) else {
            return
        }
        
        // create a center coordinate from the last 2 scans
        let centerCoordinate = CLLocationCoordinate2D(
            //latitude: (lastCoordinate.latitude + secondLastCoordinate.latitude) / 2,
            //longitude: (lastCoordinate.longitude + secondLastCoordinate.longitude) / 2
            
            // only use last scan
            latitude: lastCoordinate.latitude,
            longitude: lastCoordinate.longitude
        )
        
        // set distance and zoom factors
        let distance = lastCoordinate.distance(to: secondLastCoordinate)
        let zoom = Double(max(distance / 1000, 0.5)) // Adjust this factor to change the zoom level
        
        // set the mapCameraPostition using the center cordinate
        mapCameraPosition = .region(MKCoordinateRegion(
            center: centerCoordinate,
            latitudinalMeters: zoom * 1000,
            longitudinalMeters: zoom * 1000
        ))
    }
//    private func setInitialCameraPosition() {
//        guard let lastScanLocation = scans.first?.location,
//              let lastCoordinate = decodeMapLocation(mapLocationData: lastScanLocation) else {
//            return
//        }
//        
//        let zoom = 0.05 // Adjust this value to change the initial zoom level
//        
//        mapCameraPosition = .region(MKCoordinateRegion(
//            center: lastCoordinate,
//            span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
//        ))
//    }
    
    private func updatePopupPosition(for cluster: ScanCluster, using proxy: MapProxy) {
        let annotationPoint = proxy.convert(cluster.coordinate, to: .local)
        
        let popupSize = CGSize(width: 200, height: 150)
        let screenSize = UIScreen.main.bounds.size
        
        let x = min(max(annotationPoint?.x ?? 0, popupSize.width / 2), screenSize.width - popupSize.width / 2)
        let y = min(max((annotationPoint?.y ?? 0) - popupSize.height, popupSize.height / 2), screenSize.height - popupSize.height / 2)
        
        popupPosition = CGPoint(x: x, y: y)
        debugText += "\nPopup position set to \(popupPosition!)"
    }

}

struct ClusterPopupView: View {
    let cluster: ScanCluster
    @Binding var selectedScan: CodeScanData?
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(cluster.title)
                    .font(.headline)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 5)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(cluster.scans, id: \.self) { scan in
                        Button(action: {
                            selectedScan = scan
                            // TODO: Launch detail view here
                        }) {
                            Text(scan.codeStingData)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(width: 200, height: 150)
    }
}

class ScanCluster: Identifiable, Hashable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    var scans: [CodeScanData]
    
    var title: String {
        scans.count > 1 ? "\(scans.count) scans" : "\(scans.count) scan"
    }
    
    init(coordinate: CLLocationCoordinate2D, scans: [CodeScanData]) {
        self.coordinate = coordinate
        self.scans = scans
    }
    
    static func == (lhs: ScanCluster, rhs: ScanCluster) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CLLocationCoordinate2D {
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        let thisLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let otherLocation = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return thisLocation.distance(from: otherLocation)
    }
}


#Preview {
    let preview = Preview()
    preview.addExampleData(CodeScanData.sampleScans)
    return MainTabView()
        .modelContainer(preview.container)
    
}


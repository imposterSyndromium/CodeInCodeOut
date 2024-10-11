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
    

    
    var body: some View {
        ZStack {
            if scans.isEmpty {
                ContentUnavailableView("No scans yet!", systemImage: "qrcode.viewfinder", description: Text("There are no scanned codes yet. Press to scan a code with your camera to start"))
            } else if hasValidLocations() {
                Map(position: $mapCameraPosition, selection: $selectedCluster) {
                    ForEach(createClusters()) { cluster in
                        Marker(cluster.title, coordinate: cluster.coordinate)
                            .tag(cluster)
                    }
                }
                .onAppear(perform: setInitialCameraPosition)
                .onChange(of: selectedCluster) { oldValue, newValue in
                    if let selected = newValue {
                        print("Selected cluster with \(selected.scans.count) scans")
                        updatePopupPosition(for: selected)
                    } else {
                        popupPosition = nil
                    }
                }
                
                if let cluster = selectedCluster, let position = popupPosition {
                    ClusterPopupView(cluster: cluster, selectedScan: $selectedScan)
                        .position(x: position.x, y: position.y)
                        .transition(.scale)
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
        let clusteringDistance: CLLocationDistance = 250 // 1 km
        
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
        guard let lastScanLocation = scans.first?.location,
              let lastCoordinate = decodeMapLocation(mapLocationData: lastScanLocation),
              let secondLastScanLocation = scans.dropFirst().first?.location,
              let secondLastCoordinate = decodeMapLocation(mapLocationData: secondLastScanLocation) else {
            return
        }
        
        let centerCoordinate = CLLocationCoordinate2D(
            latitude: (lastCoordinate.latitude + secondLastCoordinate.latitude) / 2,
            longitude: (lastCoordinate.longitude + secondLastCoordinate.longitude) / 2
        )
        
        let distance = lastCoordinate.distance(to: secondLastCoordinate)
        let zoom = Double(max(distance / 1000, 0.5)) // Adjust this factor to change the zoom level
        
        mapCameraPosition = .region(MKCoordinateRegion(
            center: centerCoordinate,
            latitudinalMeters: zoom * 1000,
            longitudinalMeters: zoom * 1000
        ))
    }
    
    private func updatePopupPosition(for cluster: ScanCluster) {
        guard let mapRect = (mapCameraPosition.region)?.toMKMapRect() else {
                return
            }
            
            let mapFrame = UIScreen.main.bounds
            let convertedPoint = cluster.coordinate.point(for: mapRect, in: mapFrame)
            
            let popupSize = CGSize(width: 200, height: 150) // Estimate the size of your popup
            let screenSize = UIScreen.main.bounds.size
            
            let x = min(max(convertedPoint.x, popupSize.width / 2), screenSize.width - popupSize.width / 2)
            let y = min(max(convertedPoint.y, popupSize.height / 2), screenSize.height - popupSize.height / 2)
            
            popupPosition = CGPoint(x: x, y: y)
        }
}

struct ClusterPopupView: View {
    let cluster: ScanCluster
    @Binding var selectedScan: CodeScanData?
    
    var body: some View {
        VStack {
            Text(cluster.title)
                .font(.headline)
                .padding(.bottom, 5)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(cluster.scans, id: \.self) { scan in
                        Button(action: {
                            selectedScan = scan
                            // Here you can navigate to a detail view or perform other actions
                            // showDetailView(for: selectedScan)
                        }) {
                            Text(scan.codeStingData)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
            }
            .frame(maxHeight: 100)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

class ScanCluster: Identifiable, Hashable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    var scans: [CodeScanData]
    
    var title: String {
        scans.count > 1 ? "\(scans.count) scans" : scans.first?.codeStingData ?? "Scan"
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
    
    func point(for mapRect: MKMapRect, in frame: CGRect) -> CGPoint {
        let topLeft = mapRect.origin.coordinate
        let bottomRight = MKMapPoint(x: mapRect.maxX, y: mapRect.maxY).coordinate
        
        let latRatio = (topLeft.latitude - self.latitude) / (topLeft.latitude - bottomRight.latitude)
        let lonRatio = (self.longitude - topLeft.longitude) / (bottomRight.longitude - topLeft.longitude)
        
        return CGPoint(
            x: frame.width * lonRatio,
            y: frame.height * latRatio
        )
    }
}

extension MKCoordinateRegion {
    func toMKMapRect() -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: center.latitude + span.latitudeDelta / 2, longitude: center.longitude - span.longitudeDelta / 2)
        let bottomRight = CLLocationCoordinate2D(latitude: center.latitude - span.latitudeDelta / 2, longitude: center.longitude + span.longitudeDelta / 2)
        
        let topLeftPoint = MKMapPoint(topLeft)
        let bottomRightPoint = MKMapPoint(bottomRight)
        
        return MKMapRect(x: topLeftPoint.x,
                         y: topLeftPoint.y,
                         width: abs(bottomRightPoint.x - topLeftPoint.x),
                         height: abs(bottomRightPoint.y - topLeftPoint.y))
    }
}


#Preview {
    let preview = Preview()
    preview.addExampleData(CodeScanData.sampleScans)
    return MainTabView()
        .modelContainer(preview.container)
    
}


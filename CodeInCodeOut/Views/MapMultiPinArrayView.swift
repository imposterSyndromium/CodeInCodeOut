//
//  MapMultiPinArrayView.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-10-04.
//


/// This code is a combination of me writing a view, and asking AI to enhance its capabilities.  AI did the clusters, initial location, popup menu.
///
/// still a work in progress, but manual now.  Ai made it way too complex, but I kept some features (scan clusters)
///
import MapKit
import SwiftData
import SwiftUI


struct MapMultiPinArrayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CodeScanData.dateAdded, order: .reverse) private var scans: [CodeScanData]
    
    @State private var selectedCluster: ScanCluster?
    @State private var selectedScan: CodeScanData?
    
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    @State private var showMenu: Bool = false
    
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
                                    .frame(width: 34, height: 34)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onTapGesture {
                                        selectedCluster = cluster
                                        withAnimation(.snappy) {
                                            showMenu = true // show the menu when a cluster is tapped
                                        }
                                    }
                            }
                            .tag(cluster)
                            
                        }
                    }
                    .mapStyle(.hybrid)
                    .onAppear(perform: setInitialCameraPosition)
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
            
            
            CardContextMenu(isPresented: $showMenu) {
                VStack(spacing: 20) {
                    Text("Scans at this location:")
                        .font(.headline)
                    
                    ForEach(selectedCluster!.scans) { scan in
                        NavigationLink(destination: DetailView(codeScan: scan)) {
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(scan.codeStingData)
                                            .font(.headline)
                                        Text(scan.dateAdded.formatted(date: .abbreviated, time: .shortened))
                                    }
                                    
                                    if scan.isFavorite {
                                        Spacer()
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.yellow)
                                            .padding(.bottom, 10)
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    Button("Close") {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showMenu = false
                            selectedCluster = nil  // Reset selected cluster when closing
                        }
                    }
                    .foregroundStyle(.red).bold()
                }
                
            }
            
        } //ZStack
        .navigationTitle("Scan Locations").navigationBarTitleDisplayMode(.inline)
        

    }        
}




extension MapMultiPinArrayView {
    
    
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
        let clusteringDistance: CLLocationDistance = 200 // meters
        
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

    
}







#Preview {
    let preview = Preview()
    preview.addExampleData(CodeScanData.sampleScans)
    return MainTabView()
        .modelContainer(preview.container)
    
}


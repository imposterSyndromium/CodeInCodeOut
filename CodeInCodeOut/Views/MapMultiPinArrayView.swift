//
//  MapMultiPinArrayView.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-10-04.
//


import MapKit
import SwiftData
import SwiftUI


struct MapMultiPinArrayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CodeScanData.dateAdded, order: .reverse) private var scans: [CodeScanData]
    @Binding var selectedTab: Int
    
    @State private var selectedCluster: ScanCluster?
    @State private var selectedScan: CodeScanData?
    
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    @State private var showMenu: Bool = false
    
    @State private var showDebugText: Bool = false
    @State private var debugText: String = ""
    
    

    var body: some View {
        ZStack {
            if scans.isEmpty {
                
                ContentUnavailableView("No scans yet!", systemImage: "qrcode.viewfinder", description: Text("There are no scanned codes yet. Scan a code with your camera to start"))
                    .foregroundStyle(.gray)
                
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
                        NavigationLink(destination: DetailView(codeScan: scan, selectedTab: $selectedTab)) {
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
                        withAnimation(.easeOut(duration: 0.27)) {
                            showMenu = false
                            selectedCluster = nil  // Reset selected cluster when closing
                        }
                    }
                    .foregroundStyle(.red).bold()
                }
                
            }
            
            
        } //ZStack
        .navigationTitle("Scan Locations").navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedTab) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showMenu = false                
            }
        }
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
        let clusteringDistance: CLLocationDistance = 50 // meters
        
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
        // make sure we can get last scan
        guard let lastScanLocation = scans.first?.location,
              let lastCoordinate = decodeMapLocation(mapLocationData: lastScanLocation)
        else {
            return
        }
        
        // if there is more than one scan, use second last scan.  Else use last scan instead
        var secondLastCoordinate: CLLocationCoordinate2D
        if let secondLastScanLocation = scans.dropFirst().first?.location {
            secondLastCoordinate = decodeMapLocation(mapLocationData: secondLastScanLocation) ?? lastCoordinate
        } else {
            secondLastCoordinate = lastCoordinate
        }
        
        // create a center coordinate from the last 2 scans
        let centerCoordinate = CLLocationCoordinate2D(
            latitude: (lastCoordinate.latitude + secondLastCoordinate.latitude) / 2,
            longitude: (lastCoordinate.longitude + secondLastCoordinate.longitude) / 2
        )
        
        // set distance and zoom factors
        let distance = lastCoordinate.distance(to: secondLastCoordinate)
        let zoom = Double(max(distance / 750, 1.0)) // Adjust this factor to change the zoom level
        
        // set the mapCameraPostition using the center cordinate
        mapCameraPosition = .region(MKCoordinateRegion(
            center: centerCoordinate,
            latitudinalMeters: zoom * 1000,
            longitudinalMeters: zoom * 1000
        ))
    }
    
   
}






//
//#Preview {
//    let preview = Preview()
//    preview.addExampleData(CodeScanData.sampleScans)
//    return MainTabView()
//        .modelContainer(preview.container)
//    
//}


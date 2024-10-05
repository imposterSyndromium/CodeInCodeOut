//
//  MapMultiPinArrayView.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-10-04.
//


import MapKit
import SwiftData
import SwiftUI


// this is almost 100% AI generated - just playing


/// A SwiftUI view that displays a map with clustered pins representing scanned code data.
///
/// This view uses SwiftData to fetch and display `CodeScanData` objects on a map.
/// It clusters nearby scans and allows users to interact with these clusters.
struct MapMultiPinArrayView: View {
    /// The model context for SwiftData operations.
    @Environment(\.modelContext) private var modelContext
    
    /// A query fetching all `CodeScanData` objects from SwiftData.
    @Query private var scans: [CodeScanData]
    
    /// The currently selected cluster of scans.
    @State private var selectedCluster: ScanCluster?
    
    /// The currently selected individual scan.
    @State private var selectedScan: CodeScanData?
    
    /// The visible region of the map.
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    /// An array of clustered scan data.
    @State private var clusters: [ScanCluster] = []

    var body: some View {
        VStack {
            if scans.isEmpty {
                ContentUnavailableView("No scans yet!",
                                       systemImage: "qrcode.viewfinder",
                                       description: Text("There are no scanned codes yet. Press to scan a code with your camera to start"))
            } else if hasValidLocations() {
                Map(coordinateRegion: $region, annotationItems: clusters) { cluster in
                    MapAnnotation(coordinate: cluster.coordinate) {
                        PinWithMenu(cluster: cluster, selectedCluster: $selectedCluster, onScanSelected: { scan in
                            selectedScan = scan
                            showDetailView(for: selectedScan)
                        })
                    }
                }
            } else {
                ContentUnavailableView("Locations not available",
                                       systemImage: "location.slash",
                                       description: Text("There is no location history for any scans. To enable future scan location availability, go to Settings > Privacy & Security > Location Services > CodeInCodeOut"))
            }
        }
        .onAppear(perform: updateClusters)
        .onChange(of: scans) { _ in
            updateClusters()
        }
    }
    
    /// Checks if there are any scans with valid locations.
    ///
    /// - Returns: `true` if at least one scan has a valid location, `false` otherwise.
    private func hasValidLocations() -> Bool {
        scans.contains { scan in
            guard let location = scan.location else { return false }
            return decodeMapLocation(mapLocationData: location) != nil
        }
    }
    
    /// Handles the selection of a scan, typically to show more details.
    ///
    /// - Parameter scan: The `CodeScanData` object that was selected, if any.
    private func showDetailView(for scan: CodeScanData?) {
        if let scan = scan {
            print("Selected scan: \(scan)")
            // Navigate to the detailed view of the selected scan here
        }
    }
    
    /// Updates the clusters based on the current scans.
    ///
    /// This method is called when the view appears and when the scans change.
    /// It performs the clustering operation on a background thread to avoid blocking the UI.
    private func updateClusters() {
        DispatchQueue.global(qos: .userInitiated).async {
            let newClusters = createClusters()
            DispatchQueue.main.async {
                self.clusters = newClusters
            }
        }
    }
    
    /// Creates clusters from the available scans.
    ///
    /// This method groups nearby scans into clusters based on their geographical proximity.
    ///
    /// - Returns: An array of `ScanCluster` objects representing the grouped scans.
    private func createClusters() -> [ScanCluster] {
        let validScans = scans.compactMap { scan -> (CodeScanData, CLLocationCoordinate2D)? in
            guard let location = scan.location,
                  let coordinate = decodeMapLocation(mapLocationData: location) else {
                return nil
            }
            return (scan, coordinate)
        }
        
        var clusters: [ScanCluster] = []
        let clusteringDistance: CLLocationDistance = 1000 // 1 kilometer
        
        for (scan, coordinate) in validScans {
            if let existingClusterIndex = clusters.firstIndex(where: { $0.coordinate.distance(to: coordinate) <= clusteringDistance }) {
                clusters[existingClusterIndex].scans.append(scan)
            } else {
                clusters.append(ScanCluster(coordinate: coordinate, scans: [scan]))
            }
        }
        
        return clusters
    }
}

/// Represents a cluster of scans on the map.
///
/// This class groups multiple `CodeScanData` objects that are geographically close to each other.
class ScanCluster: Identifiable, Hashable, ObservableObject {
    /// A unique identifier for the cluster.
    let id = UUID()
    
    /// The geographical coordinate of the cluster's center.
    let coordinate: CLLocationCoordinate2D
    
    /// The scans that belong to this cluster.
    @Published var scans: [CodeScanData]
    
    /// A descriptive title for the cluster, based on the number of scans it contains.
    var title: String {
        scans.count > 1 ? "\(scans.count) scans" : scans.first?.codeStingData ?? "Scan"
    }
    
    /// Initializes a new cluster with a coordinate and an array of scans.
    ///
    /// - Parameters:
    ///   - coordinate: The geographical coordinate for the cluster's center.
    ///   - scans: An array of `CodeScanData` objects belonging to this cluster.
    init(coordinate: CLLocationCoordinate2D, scans: [CodeScanData]) {
        self.coordinate = coordinate
        self.scans = scans
    }
    
    /// Compares two `ScanCluster` objects for equality.
    ///
    /// Two clusters are considered equal if they have the same `id`.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `ScanCluster` to compare.
    ///   - rhs: The right-hand side `ScanCluster` to compare.
    /// - Returns: `true` if the clusters are equal, `false` otherwise.
    static func == (lhs: ScanCluster, rhs: ScanCluster) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Hashes the essential components of the cluster.
    ///
    /// - Parameter hasher: The hasher to use when combining the components of the cluster.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// A view that represents a pin on the map with an expandable menu of scans.
struct PinWithMenu: View {
    /// The cluster of scans this pin represents.
    @ObservedObject var cluster: ScanCluster
    
    /// Binding to the currently selected cluster.
    @Binding var selectedCluster: ScanCluster?
    
    /// A closure to call when a scan is selected from the menu.
    let onScanSelected: (CodeScanData) -> Void
    
    /// Controls the visibility of the expanded menu.
    @State private var isMenuVisible = false
    
    /// The minimum width for the menu to ensure readability.
    private let minMenuWidth: CGFloat = 200
    
    /// The maximum number of items to show in the menu before scrolling.
    private let maxVisibleItems = 5

    var body: some View {
        ZStack(alignment: .top) {
            pinView
            
            if isMenuVisible {
                menuView
                    .offset(y: 40)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(width: max(minMenuWidth, 30))
    }
    
    private var pinView: some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .frame(width: 30, height: 30)
            
            Text("\(cluster.scans.count)")
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
        }
        .background(
            Circle()
                .fill(Color.white)
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
                .frame(width: 34, height: 34)
        )
        .onTapGesture {
            withAnimation(.spring()) {
                if selectedCluster == cluster {
                    isMenuVisible.toggle()
                } else {
                    selectedCluster = cluster
                    isMenuVisible = true
                }
            }
        }
    }
    
    private var menuView: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(Array(cluster.scans.prefix(maxVisibleItems)), id: \.self) { scan in
                Button(action: {
                    onScanSelected(scan)
                    withAnimation(.spring()) {
                        isMenuVisible = false
                    }
                }) {
                    Text(scan.codeStingData)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .frame(minWidth: minMenuWidth - 16, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(4)
                }
            }
            
            if cluster.scans.count > maxVisibleItems {
                Text("... and \(cluster.scans.count - maxVisibleItems) more")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .overlay(
            Triangle()
                .fill(Color.white)
                .frame(width: 20, height: 10)
                .offset(y: -18)
        )
    }
}

/// A custom shape for creating a triangle pointer above the menu.
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

extension CLLocationCoordinate2D {
    /// Calculates the distance between two coordinates.
    ///
    /// - Parameter other: The other coordinate to calculate the distance to.
    /// - Returns: The distance in meters between the two coordinates.
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        let thisLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let otherLocation = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return thisLocation.distance(from: otherLocation)
    }
}

//import MapKit
//import SwiftData
//import SwiftUI
//
//struct MapMultiPinArrayView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var scans: [CodeScanData]
//    @State private var selectedCluster: ScanCluster?
//    @State private var selectedScan: CodeScanData?
//    
//    var body: some View {
//        VStack {
//            if scans.isEmpty {
//                ContentUnavailableView("No scans yet!", systemImage: "qrcode.viewfinder", description: Text("There are no scanned codes yet. Press to scan a code with your camera to start"))
//                
//            } else if hasValidLocations() {
//                Map(selection: $selectedCluster) {
//                    ForEach(createClusters()) { cluster in
//                        Marker(cluster.title, coordinate: cluster.coordinate)
//                            .tag(cluster)
//                    }
//                }
//                .onChange(of: selectedCluster) { oldValue, newValue in
//                    if let selected = newValue {
//                        print("Selected cluster with \(selected.scans.count) scans")
//                        // Here you can trigger your detail view presentation
//                        // showing all scans in the selected cluster
//                    }
//                }
//                
//                if let cluster = selectedCluster {
//                    Menu {
//                        ForEach(cluster.scans, id: \.self) { scan in
//                            Button(scan.codeStingData) {
//                                selectedScan = scan
//                                // Here you can navigate to a detail view or perform other actions
//                                //showDetailView(for: selectedScan)
//                            }
//                        }
//                    } label: {
//                        Label("Select a Scan", systemImage: "arrow.down.circle")
//                            .padding()
//                    }
//                }
//                
//            } else {
//                ContentUnavailableView("Locations not available", systemImage: "location.slash", description: Text("There is no location history for any scans. To enable future scan location availability, go to Settings > Privacy & Security > Location Services > CodeInCodeOut"))
//            }
//        }
//    }
//    
//    
//    private func hasValidLocations() -> Bool {
//        scans.contains { scan in
//            guard let location = scan.location else { return false }
//            return decodeMapLocation(mapLocationData: location) != nil
//        }
//    }
//    
//    
//    private func createClusters() -> [ScanCluster] {
//        let validScans = scans.compactMap { scan -> (CodeScanData, CLLocationCoordinate2D)? in
//            guard let location = scan.location,
//                  let coordinate = decodeMapLocation(mapLocationData: location) else {
//                return nil
//            }
//            return (scan, coordinate)
//        }
//        
//        var clusters: [ScanCluster] = []
//        let clusteringDistance: CLLocationDistance = 1000 // 1 km
//        
//        for (scan, coordinate) in validScans {
//            if let existingClusterIndex = clusters.firstIndex(where: { $0.coordinate.distance(to: coordinate) <= clusteringDistance }) {
//                clusters[existingClusterIndex].scans.append(scan)
//            } else {
//                clusters.append(ScanCluster(coordinate: coordinate, scans: [scan]))
//            }
//        }
//        
//        return clusters
//    }
//}
//
//class ScanCluster: Identifiable, Hashable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//    var scans: [CodeScanData]
//    
//    var title: String {
//        scans.count > 1 ? "\(scans.count) scans" : scans.first?.codeStingData ?? "Scan"
//    }
//    
//    init(coordinate: CLLocationCoordinate2D, scans: [CodeScanData]) {
//        self.coordinate = coordinate
//        self.scans = scans
//    }
//    
//    static func == (lhs: ScanCluster, rhs: ScanCluster) -> Bool {
//        lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//
//extension CLLocationCoordinate2D {
//    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
//        let thisLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
//        let otherLocation = CLLocation(latitude: other.latitude, longitude: other.longitude)
//        return thisLocation.distance(from: otherLocation)
//    }
//}

#Preview {
    let preview = Preview()
    preview.addExampleData(CodeScanData.sampleScans)
    return MainTabView()
        .modelContainer(preview.container)
    
}


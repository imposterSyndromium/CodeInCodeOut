//
//  ScanCluster.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-10-13.
//

import Foundation
import MapKit

/// A class that represents a cluster of scan data at a specific geographic coordinate.
/// Each `ScanCluster` instance groups multiple scans together and provides a unique identifier.
///
/// Example usage:
/// ```swift
/// private func createClusters() -> [ScanCluster] {
///     let validScans = scans.compactMap { scan -> (CodeScanData, CLLocationCoordinate2D)? in
///         guard let location = scan.location,
///               let coordinate = decodeMapLocation(mapLocationData: location) else {
///             return nil
///         }
///         return (scan, coordinate)
///     }
///
///     var clusters: [ScanCluster] = []
///     let clusteringDistance: CLLocationDistance = 50 // meters
///
///     for (scan, coordinate) in validScans {
///         if let existingClusterIndex = clusters.firstIndex(where: { $0.coordinate.distance(to: coordinate) <= clusteringDistance }) {
///             clusters[existingClusterIndex].scans.append(scan)
///         } else {
///             clusters.append(ScanCluster(coordinate: coordinate, scans: [scan]))
///         }
///     }
///
///     return clusters
/// }
/// ```
class ScanCluster: Identifiable, Hashable {
    /// A unique identifier for the cluster.
    let id = UUID()
    
    /// The geographic coordinate of the scan cluster.
    let coordinate: CLLocationCoordinate2D
    
    /// An array of scan data associated with this cluster.
    var scans: [CodeScanData]
    
    /// A title representing the number of scans in the cluster,
    /// formatted as "X scan(s)" based on the count.
    var title: String {
        scans.count > 1 ? "\(scans.count) scans" : "\(scans.count) scan"
    }
    
    /// Initializes a new `ScanCluster` instance with a coordinate and a list of scans.
    ///
    /// - Parameters:
    ///   - coordinate: The geographic coordinate where the cluster is located.
    ///   - scans: An array of `CodeScanData` representing the scans in this cluster.
    init(coordinate: CLLocationCoordinate2D, scans: [CodeScanData]) {
        self.coordinate = coordinate
        self.scans = scans
    }
    
    /// Determines equality between two `ScanCluster` instances based on their unique identifiers.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand `ScanCluster` instance in the equality comparison.
    ///   - rhs: The right-hand `ScanCluster` instance in the equality comparison.
    /// - Returns: A Boolean value indicating whether the two instances are equal.
    static func == (lhs: ScanCluster, rhs: ScanCluster) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Hashes the unique identifier of the cluster, supporting the `Hashable` protocol.
    ///
    /// - Parameter hasher: The hasher that computes the hash value for the cluster.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

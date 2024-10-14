//
//  ScanCluster.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-10-13.
//

import Foundation
import MapKit

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

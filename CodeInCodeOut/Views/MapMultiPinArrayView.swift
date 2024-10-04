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
    @Query private var scans: [CodeScanData]
    
    
    var body: some View {
        VStack {
            if scans.isEmpty {
                ContentUnavailableView("No scans yet!", systemImage: "qrcode.viewfinder", description: Text("There are no scanned codes yet. Press to scan a code with your camera to start"))
                
            } else if hasValidLocations() {
                Map {
                    ForEach(scans) { scan in
                        if let location = scan.location,
                           let coordinate = decodeMapLocation(mapLocationData: location) {
                            Marker(scan.codeStingData, coordinate: coordinate)
                        }
                    }
                }
                
            } else {
                ContentUnavailableView("Locations not available", systemImage: "location.slash", description: Text("There is no location history for any scans.  To enable future scan location availability, go to Settings > Privacy & Security > Location Services > CodeInCodeOut"))
            }
        }
    }
    
    private func hasValidLocations() -> Bool {
        scans.contains { scan in
            guard let location = scan.location else { return false }
            return decodeMapLocation(mapLocationData: location) != nil
        }
    }
    
    
}



#Preview {
    let preview = Preview()
    preview.addExampleData(CodeScanData.sampleScans)
    return MainTabView()
        .modelContainer(preview.container)
    
}


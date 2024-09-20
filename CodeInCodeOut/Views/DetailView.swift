//
//  DetailView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-15.
//

import SwiftUI

struct DetailView: View {
    @State var qrScan: QRCodeData3
    
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section("Scanned Code Data") {
                    Text(qrScan.qrCodeStringData)
                    
                }
                
                Section("Date Scanned") {
                    Text(qrScan.dateAdded.formatted(date: .abbreviated, time: .shortened))
                }
                
            }
            
            Section("Original Scan Image") {
                if let qrImage = qrScan.image {
                    ScannedImageView(imageData: qrImage)
                }
            }
            .padding()
                            
            Section("Scan Location") {
                if let location = qrScan.location {
                    MapView(locationData: location)
                }
            }
            .padding()
            
        }
        
    }
}

#Preview {
    MainMenuButtons_View()
}

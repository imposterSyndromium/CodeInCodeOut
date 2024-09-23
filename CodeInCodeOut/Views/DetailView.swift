//
//  DetailView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-15.
//

import SwiftUI

struct DetailView: View {
    @State var qrScan: QRCodeData3
    @State private var isShowingZoomableImage = false
    
    
    var body: some View {
        List {
            
            Section("Scanned Code Data") {
                Text(qrScan.qrCodeStringData)
                    .textSelection(.enabled)
                    .contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = qrScan.qrCodeStringData
                        }) {
                            Label("Copy to Clipboard", systemImage: "doc.on.doc")
                        }
                        
                        if let url = URL(string: qrScan.qrCodeStringData), UIApplication.shared.canOpenURL(url) {
                            Button(action: {
                                UIApplication.shared.open(url)
                            }) {
                                Label("Open in Browser", systemImage: "safari")
                            }
                        }
                    }
            }
            
            Section("Date Scanned") {
                Text(qrScan.dateAdded.formatted(date: .abbreviated, time: .shortened))
            }
            
            Section("Notes") {
                Text(qrScan.notes)
            }
            
            Section("Original Scan Image") {
                if let qrImage = qrScan.image {
                    
                    Button {
                       isShowingZoomableImage.toggle()
                    } label: {
                        // force unwrap the image data because we already know it has data
                        Image(uiImage: UIImage(data: qrImage)!)
                            .resizable()
                            .scaledToFit()
                    }
                    
                } else {
                    ContentUnavailableView("Image not available", systemImage: "photo", description: Text("There is no image history for this scan"))
                }
            }
            
            Section("Scan Location") {
                if let location = qrScan.location {
                    
                    MapView(locationData: location)
                        .frame(height: 400)
                        .padding()
                    
                } else {
                    ContentUnavailableView("Location not available", systemImage: "location.slash", description: Text("There is no location history for this scan.  To enable, go to Settings > Privacy & Security > Location Services > CodeInCodeOut"))
                }
            }
        }
        .sheet(isPresented: $isShowingZoomableImage) {
            ZoomableScrollableImage_View(uiImage: UIImage(data: qrScan.image!)!)
        }
 
    }
}


#Preview {
    MainTabView()
}

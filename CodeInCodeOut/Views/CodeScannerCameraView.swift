//
//  CodeScannerCamera_View.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-11.
//
import AVFoundation
import CodeScanner
import SwiftData
import SwiftUI

struct CodeScannerCameraView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let locationFetcher = LocationFetcher()
    let simulatedData: String = "This is a string of simulated code data 1234567890"
    let codeScanTypes: [AVMetadataObject.ObjectType] = [.code39, .code93, .code128, .code39Mod43, .qr, .microQR, .upce,.ean8, .ean13, .dataMatrix, .pdf417, .microPDF417, .aztec]
    
    
    var body: some View {
        VStack {
            CodeScannerView(codeTypes: codeScanTypes,
                            requiresPhotoOutput: true,
                            simulatedData: simulatedData,
                            completion: handleScan)
        }
        .navigationTitle("Code Scanner").navigationBarTitleDisplayMode(.inline)
    }
    
    
}





extension CodeScannerCameraView {
    
    @MainActor
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let image = result.image?.toData()
            
            let scannedCode = CodeScanData(id: UUID(), codeStringData: result.string,  isFavorite: false, dateAdded: Date.now, notes: "", image: image)
            
            if appStateManager.locationAuthorizationStatus == .authorizedAlways || appStateManager.locationAuthorizationStatus == .authorizedWhenInUse {
                // get location if the user has approved location tracking (approval happen at app start using appStateManager)
                locationFetcher.getLocation(timeout: 5) { locationData in
                    if let locationData = locationData {
                        scannedCode.location = locationData
                    } else {
                        print("Location data not captured")
                    }
                }
            } else {
                print("Location access has not been approved")
            }
            
            self.modelContext.insert(scannedCode)
            print("Success scanning barcode: \(scannedCode.codeStingData)")
            dismiss()
            
        case .failure(let error):
            print("Scanning Failed: \(error.localizedDescription)")
            dismiss()
        }
    }
}





#Preview {
    CodeScannerCameraView()
}

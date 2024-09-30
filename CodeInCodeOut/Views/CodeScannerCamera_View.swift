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

struct CodeScannerCamera_View: View {
    @EnvironmentObject var appStateManager: AppStateManager
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    let locationFetcher = LocationFetcher()

    let codeScanTypes: [AVMetadataObject.ObjectType] = [.code39, .code93, .code128, .code39Mod43, .qr, .microQR, .upce,.ean8, .ean13, .dataMatrix, .pdf417, .microPDF417, .aztec]
    let simulatedData: String = "This is a string of simulated code data 1234567890"
    
    
    
    
    var body: some View {
        VStack {
            CodeScannerView(codeTypes: codeScanTypes,
                            requiresPhotoOutput: true,
                            simulatedData: simulatedData,
                            completion: handleScan)
        }
        .navigationTitle("Code Scanner").navigationBarTitleDisplayMode(.inline)
    }
    
    
    
    
    @MainActor
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let image = result.image?.toData()
            
            let scannedCode = CodeScanData(id: UUID(), codeStringData: result.string, emailAddress: "myEmail@emailMe.com", isFavorite: false, dateAdded: Date.now, notes: "This is some data that belongs in notes", image: image)
            
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
    CodeScannerCamera_View()
}

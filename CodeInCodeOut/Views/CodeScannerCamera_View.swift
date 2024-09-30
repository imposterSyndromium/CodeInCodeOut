//
//  CodeScannerCamera_View.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-11.
//
import AVFoundation
import CodeScanner
import SwiftUI

struct CodeScannerCamera_View: View {
    @EnvironmentObject var appStateManager: AppStateManager
    @Environment(\.dismiss) var dismiss
    
    @State var viewModel: QRData_ViewModel
    @State private var showViewFinderSquare = false
    let locationFetcher = LocationFetcher()

    let codeTypes: [AVMetadataObject.ObjectType] = [.code39, .code93, .code128, .code39Mod43, .qr, .microQR, .upce,.ean8, .ean13, .dataMatrix, .pdf417, .microPDF417, .aztec]
    
    
    var body: some View {
        VStack {
            CodeScannerView(codeTypes: codeTypes,
                            showViewfinder: showViewFinderSquare,
                            requiresPhotoOutput: true,
                            simulatedData: "This is a string of test String data.",
                            completion: handleScan)
        }
        .navigationTitle("Code Scanner").navigationBarTitleDisplayMode(.inline)
        
    }
    
    
    
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let image = result.image?.toData()
            
            let qrCode = QRCodeData3(id: UUID(), qrCodeStringData: result.string, emailAddress: "myEmail@emailMe.com", isFavorite: false, dateAdded: Date(), notes: "This is some data that belongs in notes", image: image)
            
            if appStateManager.locationAuthorizationStatus == .authorizedAlways || appStateManager.locationAuthorizationStatus == .authorizedWhenInUse {
                // get location if the user has approved location tracking (approval happen at app start using appStateManager)
                locationFetcher.getLocation(timeout: 5) { locationData in
                    if let locationData = locationData {
                        qrCode.location = locationData
                    } else {
                        print("Location data not captured")
                    }
                }
            } else {
                print("Location access has not been approved")
            }
            
            Task { @MainActor in
                self.viewModel.appendItem(qrCode)
            }
            
            print("Success scanning barcode: \(qrCode.qrCodeStringData)")
            viewModel.isShowingScanner = false
            
        case .failure(let error):
            print("Scanning Failed: \(error.localizedDescription)")
            dismiss()
        }
    }
    
    
}





#Preview {
    CodeScannerCamera_View(viewModel: QRData_ViewModel())
}

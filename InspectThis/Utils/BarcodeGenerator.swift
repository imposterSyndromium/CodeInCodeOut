//
//  BarcodeGenerator.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//
import CoreImage.CIFilterBuiltins
import Foundation
import SwiftUI

enum BarcodeType: String, CaseIterable, Identifiable {
    case code128 = "Code 128"
    case qr = "QR Code"
    case aztec = "Aztec"
    case pdf417 = "PDF417"
    
    var id: String { self.rawValue }
}

struct BarcodeGenerator {
    let context = CIContext()
    
    func generateBarcode(text: String, type: BarcodeType) -> Image {
        let filter: CIFilter
        switch type {
        case .code128:
            filter = CIFilter.code128BarcodeGenerator()
        case .qr:
            filter = CIFilter.qrCodeGenerator()
        case .aztec:
            filter = CIFilter.aztecCodeGenerator()
        case .pdf417:
            filter = CIFilter.pdf417BarcodeGenerator()
        }
        
        filter.setValue(Data(text.utf8), forKey: "inputMessage")
                
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            return Image(uiImage: uiImage)
        }
        
        return Image(systemName: "barcode")
    }
}

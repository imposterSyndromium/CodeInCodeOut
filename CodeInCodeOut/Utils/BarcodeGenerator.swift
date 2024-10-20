//
//  BarcodeGenerator.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//



import UIKit
import CoreImage.CIFilterBuiltins


enum BarcodeType: String, CaseIterable, Identifiable {
    case code128 = "Code 128"
    case qr = "QR Code"
    case aztec = "Aztec"
    case pdf417 = "PDF417"

    var id: String { self.rawValue }
}
    
    
struct BarcodeGenerator {
    let context = CIContext()
    
    func generateBarcode(text: String, type: BarcodeType) -> UIImage {
        let filter: CIFilter
        let targetSize: CGSize
        
        switch type {
        case .pdf417:
            filter = CIFilter.pdf417BarcodeGenerator()
            targetSize = CGSize(width: 500, height: 300)
        case .aztec:
            filter = CIFilter.aztecCodeGenerator()
            targetSize = CGSize(width: 500, height: 500)
        case .code128:
            filter = CIFilter.code128BarcodeGenerator()
            targetSize = CGSize(width: 500, height: 250)
        case .qr:
            filter = CIFilter.qrCodeGenerator()
            targetSize = CGSize(width: 500, height: 500)
        }
        
        filter.setValue(Data(text.utf8), forKey: "inputMessage")
                
        if let outputImage = filter.outputImage {
            let scaleX = targetSize.width / outputImage.extent.size.width
            let scaleY = targetSize.height / outputImage.extent.size.height
            
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                let uiImage = UIImage(cgImage: cgImage)
                return addTextToImage(uiImage, text: text)
            }
        }
        
        return UIImage()
    }
    
    
}


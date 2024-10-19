//
//  BarcodeGenerator.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//
import CoreImage.CIFilterBuiltins
import SwiftUI

// the enums to be used in BarcodeGenerator for a CoreImage.Filter
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
            // Calculate scale factors
            let scaleX = targetSize.width / outputImage.extent.size.width
            let scaleY = targetSize.height / outputImage.extent.size.height
            
            // Apply scaling to the image
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            
            // Create the CGImage from the scaled image
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                // Create a UIImage
                let uiImage = UIImage(cgImage: cgImage)
                
                // Add text to the image
                return addTextToImage(uiImage, text: text)
            }
        }
        
        // There is no barcode or image to decode, so return an empty image
        return UIImage()
    }
    
    func addTextToImage(_ image: UIImage, text: String) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: image.size.width, height: image.size.height + 40), false, scale)
        
        image.draw(at: CGPoint.zero)
        
        let rect = CGRect(x: 0, y: image.size.height, width: image.size.width, height: 40)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.black
        ]
        
        text.draw(with: rect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
}
//struct BarcodeGenerator {
//    let context = CIContext()
//    
//    func generateBarcode(text: String, type: BarcodeType) -> UIImage {
//        let filter: CIFilter
//        let targetSize: CGSize
//        
//        switch type {
//        case .pdf417:
//            filter = CIFilter.pdf417BarcodeGenerator()
//            targetSize = CGSize(width: 500, height: 300)
//        case .aztec:
//            filter = CIFilter.aztecCodeGenerator()
//            targetSize = CGSize(width: 500, height: 500)
//        case .code128:
//            filter = CIFilter.code128BarcodeGenerator()
//            targetSize = CGSize(width: 500, height: 250)
//        case .qr:
//            filter = CIFilter.qrCodeGenerator()
//            targetSize = CGSize(width: 500, height: 500)
//        }
//        
//        filter.setValue(Data(text.utf8), forKey: "inputMessage")
//                
//        if let outputImage = filter.outputImage {           
//            // Calculate scale factors
//            let scaleX = targetSize.width / outputImage.extent.size.width
//            let scaleY = targetSize.height / outputImage.extent.size.height
//            
//            // Apply scaling to the image
//            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
//            
//            // Create the CGImage from the scaled image
//            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
//                // Create and return a UIImage
//                let uiImage = UIImage(cgImage: cgImage)
//                return uiImage
//            }
//        }
//        
//        // There is no barcode or image to decode, so return an empty image
//        return UIImage()
//    }
//    
//    
//    
//}

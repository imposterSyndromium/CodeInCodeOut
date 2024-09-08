//
//  GenerateAndShareQR.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//
import CoreImage.CIFilterBuiltins
import SwiftUI

struct GenerateAndShareQR: View {
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress = "me@me.com"
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .autocorrectionDisabled(true)
                    .textContentType(.name)
                    .font(.title2)
                
                TextField("Email address", text: $emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textContentType(.emailAddress)
                    //.font(.headline)
                
                Image(uiImage: qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 200)
                    .contextMenu {
                        ShareLink(item: Image(uiImage: qrCode), preview: SharePreview("My QR Code", image: Image(uiImage: qrCode)))
                    }
                
                Text("Press and hold the QR Code to send it")
            }
            .navigationTitle("Your QR Code")
            .onAppear(perform: updateQRCode)
            .onChange(of: name, updateQRCode)
            .onChange(of: emailAddress, updateQRCode)
        }
    }
    
    
    func updateQRCode() {
        let smallQRCode = generateQRCode(from: "\(name)\n\(emailAddress)")
        
        if let image = resizeImage(smallQRCode, targetSize: CGSize(width: 400, height: 400)) {
            qrCode = image
        }
    }
    
    
    func generateQRCode(from string: String) -> UIImage {
        //let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                qrCode = UIImage(cgImage: cgImage)
                return qrCode
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
    // Function to resize a UIImage without interpolation
    func resizeImage(_ image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let image = image else { return nil }

        let rect = CGRect(origin: .zero, size: targetSize)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        
        // Set interpolation quality to none
        UIGraphicsGetCurrentContext()?.interpolationQuality = .none
        
        image.draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}

#Preview {
    GenerateAndShareQR()
}

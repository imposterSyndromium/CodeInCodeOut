//
//  QRImageView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-11.
//

import SwiftUI

struct QRImageView: View {
    var imageData: Data
    
    var body: some View {
        VStack{
            Image(uiImage: UIImage(data: imageData)!)
        }
        .navigationTitle("QR Scans")
    }
}



//
//#Preview {
//    QRImageView()
//}

//
//  QRImageView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-11.
//

import SwiftUI

struct ScannedImageView: View {
    var imageData: Data
    
    var body: some View {
        VStack{
            Image(uiImage: UIImage(data: imageData)!)
                .resizable()
                .scaledToFit()
        }
        
    }
}



//
//#Preview {
//    QRImageView()
//}

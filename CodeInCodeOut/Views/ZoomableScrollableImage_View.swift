//
//  ZoomableScrollableImage_View.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-21.
//

import SwiftUI

struct ZoomableScrollableImage_View: View {
    @Environment(\.dismiss) var dismiss
    var uiImage: UIImage
    
    var body: some View {
        VStack {
            HStack {
                Button("Close") {
                    dismiss()
                }
                Spacer()
            }
            .padding()
            
            ZoomableScrollableImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}


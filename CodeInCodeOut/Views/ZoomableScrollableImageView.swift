//
//  ZoomableScrollableImage_View.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-21.
//

import SwiftUI

struct ZoomableScrollableImageView: View {
    @Environment(\.dismiss) var dismiss
    var uiImage: UIImage
    
    var body: some View {
        ZStack {
            ZoomableScrollableImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue.opacity(0.75))
                            .clipShape(Circle())
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
}


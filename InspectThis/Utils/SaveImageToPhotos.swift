//
//  SaveImageToPhotos.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-09.
//

import Foundation
import Photos
import SwiftUI

//func saveImageToPhotoLibrary(_ image: UIImage) {
//        PHPhotoLibrary.requestAuthorization { status in
//            guard status == .authorized else {
//                alertMessage = "Permission denied to access photo library"
//                showingAlert = true
//                return
//            }
//            
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAsset(from: image)
//            }) { success, error in
//                DispatchQueue.main.async {
//                    if success {
//                        alertMessage = "Image saved successfully"
//                    } else if let error = error {
//                        alertMessage = "Error saving image: \(error.localizedDescription)"
//                    }
//                    showingAlert = true
//                }
//            }
//        }
//    }

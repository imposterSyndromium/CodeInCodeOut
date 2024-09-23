//
//  AddTextToImage.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-11.
//

import Foundation
import SwiftUI


func addTextToImage(image: UIImage, text: String) -> UIImage {
        let scale = UIScreen.main.scale
        let fontSize: CGFloat = 14.0
        let textHeight: CGFloat = 20.0
        
        let size = CGSize(width: image.size.width, height: image.size.height + textHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        // Draw original image
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        // Setup text attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        
        // Draw text
        let textRect = CGRect(x: 0, y: image.size.height, width: size.width, height: textHeight)
        text.draw(in: textRect, withAttributes: attributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }

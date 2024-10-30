//
//  AddTextToImage.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-11.
//

//import Foundation
import SwiftUI


func addTextToImage(_ image: UIImage, text: String) -> UIImage {
    let scale = UIScreen.main.scale
    let newSize = CGSize(width: image.size.width, height: image.size.height + 60)
    
    // start recording details of the imageContext
    UIGraphicsBeginImageContextWithOptions(newSize, true, scale)

    // Draw the original image
    image.draw(in: CGRect(origin: .zero, size: image.size))

    // Create and fill white background rectangle for text area, size it relative to the original image + addition size
    let textRectangle = CGRect(x: 0, y: image.size.height, width: newSize.width, height: 60)
    UIColor.white.setFill()
    UIRectFill(textRectangle)

    // Set the word formatting
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    // set the attributes for the letters
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 24),
        .paragraphStyle: paragraphStyle,
        .foregroundColor: UIColor.black
    ]
    
    // draw the actual string onto
    text.draw(with: textRectangle, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    
    // get the image from the image context
    let newImage = UIGraphicsGetImageFromCurrentImageContext()    
    UIGraphicsEndImageContext()

    return newImage ?? image
}


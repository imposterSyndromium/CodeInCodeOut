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


//func addTextToImage(image: UIImage, text: String) -> UIImage {
//    let scale = UIScreen.main.scale
//    let fontSize: CGFloat = 14.0
//    let textHeight: CGFloat = 20.0
//    
//    let size = CGSize(width: image.size.width, height: image.size.height + textHeight)
//    
//    UIGraphicsBeginImageContextWithOptions(size, false, scale)
//    
//    // Draw original image
//    image.draw(in: CGRect(origin: .zero, size: image.size))
//    
//    // Setup text attributes
//    let paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.alignment = .center
//    let attributes: [NSAttributedString.Key: Any] = [
//        .font: UIFont.systemFont(ofSize: fontSize),
//        .foregroundColor: UIColor.black,
//        .paragraphStyle: paragraphStyle
//    ]
//    
//    // Draw text
//    let textRect = CGRect(x: 0, y: image.size.height, width: size.width, height: textHeight)
//    text.draw(in: textRect, withAttributes: attributes)
//    
//    let newImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    
//    return newImage ?? image
//}


//// Assuming you're in a view controller or have access to UIImage creation
//
//// Create a sample image
//let size = CGSize(width: 300, height: 200)
//UIGraphicsBeginImageContext(size)
//let context = UIGraphicsGetCurrentContext()!
//context.setFillColor(UIColor.blue.cgColor)
//context.fill(CGRect(origin: .zero, size: size))
//let sampleImage = UIGraphicsGetImageFromCurrentImageContext()!
//UIGraphicsEndImageContext()
//
//// Use the function
//let resultImage = addTextToImage(image: sampleImage, text: "Hello, World!")
//
//// Display the result (if in a view controller)
//let imageView = UIImageView(image: resultImage)
//view.addSubview(imageView)
//
//// Or save the image to test
//if let data = resultImage.pngData() {
//    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    let fileURL = documentsDirectory.appendingPathComponent("testImage.png")
//    try? data.write(to: fileURL)
//    print("Image saved to: \(fileURL.path)")
//}
//

//
//  UIImage_Extension.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-09.
//
import Foundation
import MapKit
import SwiftUI
import UIKit


public extension View {
//  Created by George Elsham on 15/01/2020.
//  Copyright © 2020 George Elsham. All rights reserved.
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}


// Convert a UIImage to Data? for storage
extension UIImage {
    func toData() -> Data? {
        return self.pngData()
    }
}


/// NOTE: - This is not tested properly or used in this application.
extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        
        // Set up a hosting controller with a defined size
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear
        
        // Render the view to an image
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension UIView {
    func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}



extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    
    // a very light gray
    static let listRowColor: Color = Color(UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 0.3))
}



extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


extension CLLocationCoordinate2D {
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        let thisLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let otherLocation = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return thisLocation.distance(from: otherLocation)
    }
}


extension Image {
    func addText(_ text: String) -> some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self
                    .resizable()
                    .scaledToFit()
                
                Text(text)
                    .font(.system(size: 14))
                    .padding(5)
                    .frame(width: geometry.size.width, height: 30)
                    .background(Color.white)
                    .foregroundColor(.black)
            }
        }
    }
}


extension UIImage {
    func addingText(_ text: String,
                    textColor: UIColor = .black,
                    backgroundColor: UIColor = .white,
                    font: UIFont = .systemFont(ofSize: 14),
                    textHeight: CGFloat = 30) -> UIImage {
        let scale = UIScreen.main.scale
        let size = CGSize(width: self.size.width, height: self.size.height + textHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        // Draw original image
        draw(in: CGRect(origin: .zero, size: self.size))
        
        // Draw background for text
        backgroundColor.setFill()
        let backgroundRect = CGRect(x: 0, y: self.size.height, width: size.width, height: textHeight)
        UIRectFill(backgroundRect)
        
        // Setup text attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        // Draw text
        let textRect = CGRect(x: 0, y: self.size.height, width: size.width, height: textHeight)
        text.draw(in: textRect, withAttributes: attributes)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}




//
//  UIImage_Extension.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-09.
//
import Foundation
import SwiftUI


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



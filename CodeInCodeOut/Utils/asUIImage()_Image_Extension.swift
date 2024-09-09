//
//  UIImage_Extension.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-09.
//

import SwiftUI


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

//
//  CodeScanDetail_View.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-10.
//

import SwiftUI


// Nope.  Not doing it like this.  Figure out dependancy injection with the viewmodel but use the same instance
struct CodeScanDetail_View: View {
    var qrCodeStringData: String
    var emailAddress: String
    @Binding var isFavorite: Bool
    var dateAdded: Date
    @Binding var notes: String
    var location: Data?
    var imageData: Data?
    
    
    var body: some View {
        Text(qrCodeStringData)
        Text(dateAdded, format: .dateTime)
        Text(notes)
        
        if let imageData = imageData {
            let uiImage = UIImage(data: imageData)
            
            Image(uiImage: uiImage!)
        }

        
    }
}






#Preview {
    CodeScanDetail_View(qrCodeStringData: "QRCodeData", emailAddress: "", isFavorite: .constant(true), dateAdded: Date(), notes: .constant("These are notes"))
}

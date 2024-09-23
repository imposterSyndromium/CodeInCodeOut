//
//  QRDataModel.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//
// 

import Foundation
import SwiftData

@Model
final class QRCodeData3 {
    var id: UUID
    var qrCodeStringData: String
    var emailAddress: String
    var isFavorite: Bool
    var dateAdded: Date
    var notes: String
    var location: Data?
    @Attribute(.externalStorage) var image: Data?
    
    init(id: UUID, qrCodeStringData: String, emailAddress: String, isFavorite: Bool, dateAdded: Date, notes: String, location: Data? = nil, image: Data? = nil) {
        self.id = id
        self.qrCodeStringData = qrCodeStringData
        self.emailAddress = emailAddress
        self.isFavorite = isFavorite
        self.dateAdded = dateAdded
        self.notes = notes
        self.location = location
        self.image = image
    }
}

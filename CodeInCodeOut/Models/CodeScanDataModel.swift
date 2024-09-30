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
final class CodeScanData {
    var id: UUID
    var codeStingData: String
    var emailAddress: String
    var isFavorite: Bool
    var dateAdded: Date
    var notes: String
    var location: Data?
    @Attribute(.externalStorage) var image: Data?
    
    init(id: UUID, codeStringData: String, emailAddress: String, isFavorite: Bool, dateAdded: Date, notes: String, location: Data? = nil, image: Data? = nil) {
        self.id = id
        self.codeStingData = codeStringData
        self.emailAddress = emailAddress
        self.isFavorite = isFavorite
        self.dateAdded = dateAdded
        self.notes = notes
        self.location = location
        self.image = image
    }
}

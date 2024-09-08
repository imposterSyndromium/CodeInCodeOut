//
//  QRDataModel.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//
// https://levelup.gitconnected.com/swiftui-use-swiftdata-outside-a-view-in-a-manager-class-viewmodel-d6659e7d3ad9

import Foundation
import SwiftData

@Model
final class QRCodeData2 {
    var id: UUID
    var qrCodeStringData: String
    var emailAddress: String
    var isFavorite: Bool
    var dateAdded: Date
    
    init(id: UUID, qrCodeStringData: String, emailAddress: String, isFavorite: Bool, dateAdded: Date) {
        self.id = id
        self.qrCodeStringData = qrCodeStringData
        self.emailAddress = emailAddress
        self.isFavorite = isFavorite
        self.dateAdded = dateAdded
    }
}

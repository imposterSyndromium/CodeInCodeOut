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
final class QRData {
//    var timeStamp: Date
//    
//    init(timeStamp: Date) {
//        self.timeStamp = timeStamp
//    }
    
    
    var inspectionOf: String
    var emailAddress: String
    var isInspected: Bool
    var dateAdded: Date
    
    init(inspectionOf: String, emailAddress: String, isInspected: Bool, dateAdded: Date) {
        self.inspectionOf = inspectionOf
        self.emailAddress = emailAddress
        self.isInspected = isInspected
        self.dateAdded = dateAdded
    }
    
    

}

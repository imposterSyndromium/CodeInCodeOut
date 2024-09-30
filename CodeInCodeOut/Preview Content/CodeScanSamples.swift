//
//  CodeScanSamples.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-09-30.
//

import Foundation

extension CodeScanData {
    static let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)
    static let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)
    static let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)
    
    static var sampleScans: [CodeScanData] {[
        CodeScanData(id: UUID(), codeStringData: "12345", isFavorite: true, dateAdded: lastWeek ?? Date.now, notes: "My notes 1"),
        CodeScanData(id: UUID(), codeStringData: "XE-BG1234567890", isFavorite: false, dateAdded: lastMonth ?? Date.now, notes: "Notes are here"),
        CodeScanData(id: UUID(), codeStringData: "7272727272772", isFavorite: false, dateAdded: yesterday ?? Date.now, notes: "Notes 234")
    ]}
}

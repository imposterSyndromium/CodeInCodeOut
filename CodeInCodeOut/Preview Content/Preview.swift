//
//  Preview.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-09-30.
//

import SwiftData
import Foundation

struct Preview {
    let container: ModelContainer
    
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: CodeScanData.self, configurations: config)
        } catch {
            fatalError("Could not create preview data container")
        }
    }
    
    
    func addExampleData(_ examples: [CodeScanData]) {
        Task { @MainActor in
            examples.forEach { example in
                container.mainContext.insert(example)
            }
        }
    }
}

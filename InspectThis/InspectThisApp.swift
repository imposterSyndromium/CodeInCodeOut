//
//  InspectThisApp.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//
import SwiftData
import SwiftUI

@main
struct InspectThisApp: App {
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: QRData.self)
        } catch {
            fatalError("Failed to create ModelContainer for QRData")
        }
    }
}

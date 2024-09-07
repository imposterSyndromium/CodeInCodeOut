//
//  DataSource.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-07.
//
import SwiftData
import Foundation


import SwiftData
import Foundation

final class DataSource<T: PersistentModel> {
    // Setup the SwiftData container and context
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    // Singleton instance
    @MainActor
    static func shared(for type: T.Type) -> DataSource<T> {
        DataSource<T>()
    }
    
    // initialize this class
    @MainActor
    private init() {
        do {
            self.modelContainer = try ModelContainer(for: T.self)
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
    
    // Add an item to the DB table
    func appendItem(item: T) {
        do {
            modelContext.insert(item)
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    // Get data from DB
    func fetchItems() -> [T] {
        do {
            return try modelContext.fetch(FetchDescriptor<T>())
        } catch {
            print(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    // Delete from DB
    func removeItem(_ item: T) {
        do {
            modelContext.delete(item)
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
}



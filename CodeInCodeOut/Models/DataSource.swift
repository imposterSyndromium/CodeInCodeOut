//
//  DataSource.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-07.
//
import SwiftData
import Foundation



/// DataSource is a generic class that provides a simplified interface for working with SwiftData.
/// It handles basic CRUD (Create, Read, Update, Delete) operations for any type that conforms to the PersistentModel protocol.
final class DataSource<T: PersistentModel> {
    
    /// The SwiftData container for the specific model type.
    private let modelContainer: ModelContainer
    /// The main context for performing data operations.
    private let modelContext: ModelContext
    
    
    // MARK: Singleton instance
    ///
    /// Returns a shared instance of `DataSource` for the specified `PersistentModel` type.
    /// This method ensures that only one instance of `DataSource` exists for each model type, and is
    /// marked with @MainActor to ensure it is called on only the main thread.
    ///
    /// - Parameter type: The type of the `PersistentModel`.
    /// - Returns: A shared instance of `DataSource<T>`.
    @MainActor
    static func shared(for type: T.Type) -> DataSource<T> {
        DataSource<T>()
    }
    
    
    // MARK: Initializer
    ///
    /// Private initializer to set up the SwiftData container and context.
    /// This initializer is marked with `@MainActor` to ensure it's called on the main thread.
    @MainActor
    private init() {
        do {
            self.modelContainer = try ModelContainer(for: T.self)
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
    
    
    //MARK: CRUD Operfations
    ///
    /// Adds a new item to the database.
    ///
    /// - Parameter item: The item to be added, conforming to `PersistentModel`.
    /// - Throws: A fatal error if the save operation fails.
    func appendItem(item: T) {
        do {
            modelContext.insert(item)
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    /// Retrieves all items of the specified type from the database.
    ///
    /// - Returns: An array of items conforming to `PersistentModel`.
    /// - Throws: A fatal error if the fetch operation fails.
    func fetchItems() -> [T] {
        do {
            return try modelContext.fetch(FetchDescriptor<T>())
        } catch {
            print(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    /// Removes the specified item from the database.
    ///
    /// - Parameter item: The item to be removed, conforming to `PersistentModel`.
    /// - Throws: A fatal error if the delete operation fails.
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


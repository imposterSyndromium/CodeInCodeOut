//
//  DataSource.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-07.
//
import SwiftData
import Foundation



final class DataSource {
    // Setup the SwiftData container and context
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
       
    // I've made the component a singleton so we only have one instance of the ModelContainer
    // NOTE: needs to run on the main thread to access mainContext
    @MainActor
    static let shared = DataSource()
    
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: QRData.self)
        self.modelContext = modelContainer.mainContext
    }
    
    
    // TODO how to make this argument type generic on the next functions:
    // Add an item to the DB table
    func appendItem(item: QRData) {
        do {
            modelContext.insert(item)
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    
    // get data from DB
    func fetchItems() -> [QRData] {
        do {
            return try modelContext.fetch(FetchDescriptor<QRData>())
        } catch {
            print(error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    
    
    // delete from DB
    func removeItem(_ item: QRData) {
        modelContext.delete(item)
    }
    
}


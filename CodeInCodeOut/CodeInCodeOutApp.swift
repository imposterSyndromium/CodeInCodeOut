//
//  CodeInCodeOutApp.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-09-22.
//
//
//

import SwiftData
import SwiftUI

@main
struct CodeInCodeOut_App: App {
    // create an object to store application state (eg - for location permissions)
    @StateObject private var appStateManager = AppStateManager()
    
    // create a container that we can configure manually (configured in the init)
    let container: ModelContainer
    
    
    var body: some Scene {
        WindowGroup {
            StartContainerView()
            .environmentObject(appStateManager)
            .onAppear {
                appStateManager.requestLocationPermission()
            }
        }
        .modelContainer(container) //<-- note that we are not using for: because we already defined the container vs. letting swiftData define the container
    }
    
    // This init configures a SwiftData ModelContainer manually, and names it something other than "default"
    init() {
        let schema = Schema([CodeScanData.self])
        let config = ModelConfiguration("MyCodeScans", schema: schema)
        
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure model container")
        }
        
        // print the path of the application support directory for simulator data inspection
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
  
}

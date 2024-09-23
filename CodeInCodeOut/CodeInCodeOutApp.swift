//
//  CodeInCodeOutApp.swift
//  CodeInCodeOut
//
//  Created by Robin O'Brien on 2024-09-22.
//

import SwiftUI

@main
struct CodeInCodeOut_App: App {
    @StateObject private var appStateManager = AppStateManager()
    
    var body: some Scene {
        WindowGroup {
            StartContainerView()
            .environmentObject(appStateManager)
            .onAppear {
                appStateManager.requestLocationPermission()
            }
        }
        
    }
  
}

//
//  MainMenuButtonView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//

import SwiftUI


struct MainTabView: View {  
    @EnvironmentObject var appStateManager: AppStateManager
    @State private var isShowingScanner: Bool = false
    @State private var selectedTab = 1
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            
            NavigationStack {
                CodeScannerCameraView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Scan a Code", systemImage: "camera")
            }
            .tag(0)
            
            NavigationStack {
                ScannedCodeListView(isShowingScanner: isShowingScanner, selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Scans list", systemImage: "list.bullet.clipboard")
            }
            .tag(1)
         
            NavigationStack {
                MapMultiPinArrayView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Scan Locations", systemImage: "map")
            }
            .tag(2)
            
            NavigationStack {
                GenerateCodeView()
            }
            .tabItem {
                Label("Generate Code", systemImage: "qrcode")
            }
            .tag(3)
            
            
        }
        .onAppear {
            appStateManager.requestLocationPermission()
        }
    }
}


//#Preview {
//    let preview = Preview()
//    preview.addExampleData(CodeScanData.sampleScans)
//    return MainTabView()
//        .modelContainer(preview.container)
//    
//}

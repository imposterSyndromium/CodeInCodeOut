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
    @State private var selectedTab = 0
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                ScannedCodeDataListView(isShowingScanner: isShowingScanner, selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Scan List", systemImage: "list.bullet.clipboard")
            }
            .tag(0)
         
            NavigationStack {
                MapMultiPinArrayView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Scan Locations", systemImage: "map")
            }
            .tag(1)
            
            NavigationStack {
                GenerateCodeView()
            }
            .tabItem {
                Label("Generate Code", systemImage: "qrcode")
            }
            .tag(2)
            
            
        }
        .preferredColorScheme(.dark)
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

//
//  MainMenuButtonView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedTab: String = "0"
    @State private var isShowingScanner: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                ScannedCodeDataListView(isShowingScanner: isShowingScanner)
            }
            .tabItem {
                Label("Scan List", systemImage: "list.bullet.clipboard")
            }
            .tag("0")
         
            NavigationStack {
                MapMultiPinArrayView()
            }
            .tabItem {
                Label("Scan Locations", systemImage: "map")
            }
            .tag("1")
            
            NavigationStack {
                GenerateCodeView()
            }
            .tabItem {
                Label("Generate Code", systemImage: "qrcode")
            }
            .tag("2")
            
            
        }
        .preferredColorScheme(.dark)
//        .onChange(of: scenePhase) {
//            if scenePhase == .background {
//                 selectedTab = 0
//            }
//        }
    }
}


//#Preview {
//    let preview = Preview()
//    preview.addExampleData(CodeScanData.sampleScans)
//    return MainTabView()
//        .modelContainer(preview.container)
//    
//}

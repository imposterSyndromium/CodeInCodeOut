//
//  MainMenuButtonView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//

import SwiftUI

struct MainTabView: View {

    
    var body: some View {
        TabView {
            
            NavigationStack {
                ScannedCodeDataListView()
            }
            .tabItem {
                Label("Scan List", systemImage: "list.bullet.clipboard")
            }
         
            NavigationStack {
                MapMultiPinArrayView()
            }
            .tabItem {
                Label("Scan Locations", systemImage: "map")
            }
            
            NavigationStack {
                GenerateCodeView()
            }
            .tabItem {
                Label("Generate Code", systemImage: "qrcode")
            }
            
            
        }
        .preferredColorScheme(.dark)
    }
}


#Preview {
    let preview = Preview()
    preview.addExampleData(CodeScanData.sampleScans)
    return MainTabView()
        .modelContainer(preview.container)
    
}

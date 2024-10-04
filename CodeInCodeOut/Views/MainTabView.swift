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
                Label("Scans", systemImage: "qrcode")
            }
         
            
            NavigationStack {
                GenerateCodeView()
            }
            .tabItem {
                Label("Generate code", systemImage: "barcode")
            }
            
            
        }
    }
}


#Preview {
    let preview = Preview()
    preview.addExampleData(CodeScanData.sampleScans)
    return MainTabView()
        .modelContainer(preview.container)
    
}

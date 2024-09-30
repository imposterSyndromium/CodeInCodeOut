//
//  MainMenuButtonView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//

import SwiftUI

struct MainTabView: View {
    //@State private var viewModel = QRData_ViewModel()
    
    
    var body: some View {
        TabView {
            
            NavigationStack {
                ScannedQRDataListView()
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
    MainTabView()
}

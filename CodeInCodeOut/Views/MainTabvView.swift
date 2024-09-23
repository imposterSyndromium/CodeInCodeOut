//
//  MainMenuButtonView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//

import SwiftUI

struct MainTabvView: View {
    @State private var viewModel = QRData_ViewModel()
    @State private var isShowing = false
    
    
    var body: some View {
        TabView {
            
            NavigationStack {
                ScannedQRDataListView(viewModel: viewModel, startWithScanner: false)
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
    MainTabvView()
}

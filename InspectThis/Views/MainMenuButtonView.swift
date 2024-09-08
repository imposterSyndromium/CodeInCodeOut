//
//  MainMenuButtonView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-08.
//

import SwiftUI

struct MainMenuButtonView: View {
    @State private var viewModel = QRData_ViewModel()
    @State private var isShowing = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Group{
                    NavigationLink {
                        ScannedQRDataListView(viewModel: viewModel, startWithScanner: true)
                    } label: {
                        Label("Scan Code", systemImage: "qrcode.viewfinder")
                    }
                    
                    NavigationLink {
                        ScannedQRDataListView(viewModel: viewModel, startWithScanner: false)
                    } label: {
                        Label("View past scans", systemImage: "list.bullet.rectangle.fill")
                    }
                    
                    NavigationLink {
                        Text("Generate Code View")
                    } label: {
                        Label("Generate code", systemImage: "barcode")
                    }
                }
                .padding()
                .buttonStyle(.bordered)
                .font(.title)
                
            }
            

            
        }
    }
}

#Preview {
    MainMenuButtonView()
}

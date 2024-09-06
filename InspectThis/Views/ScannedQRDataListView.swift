//
//  ScannedQRDataListView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//
import CodeScanner
import SwiftData
import SwiftUI

struct ScannedQRDataListView: View {
    @State private var viewModel: ScannedQRDataList_ViewModel
    @State private var isShowingScanner = false
    
    // inject the modelContext into this view upon creation
    init(modelContext: ModelContext) {
        let viewModel = ScannedQRDataList_ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationTitle("QR Scans")
        .toolbar {
            ToolbarItem {
                Button {
                    isShowingScanner = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                }
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr],
                            simulatedData: "Robin O'Brien/nrobin.c.obrien@gmail.com",
                            completion: handleScan)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: QRData.self, configurations: config)

    let viewModel = ScannedQRDataList_ViewModel()
    return EditingView(user: user)
     .modelContainer(container)
}

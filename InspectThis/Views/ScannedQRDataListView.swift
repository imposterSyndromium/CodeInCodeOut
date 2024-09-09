//
//  ScannedQRDataListView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//  ¬∞
import CodeScanner
import SwiftData
import SwiftUI

struct ScannedQRDataListView: View {
    @State var viewModel: QRData_ViewModel
    @State private var selectedRow = Set<QRCodeData3>()
    @State var startWithScanner: Bool
    
    var body: some View {
        VStack {
            if !viewModel.qrScans.isEmpty {
                List(selection: $selectedRow) {
                    Section(header: Text("Pinned")) {
                        ForEach(viewModel.qrScans.filter { $0.isFavorite }, id: \.id) { qrscan in
                            qrScanRow(for: qrscan)
                        }
                    }
                    
                    Section(header: Text("")) {
                        ForEach(viewModel.qrScans.filter { !$0.isFavorite }, id: \.id) { qrscan in
                            qrScanRow(for: qrscan)
                        }
                    }
                }
            } else {
                Text("No scans yet")
                    .padding(.top, 30)
                    .foregroundStyle(.secondary)
                    .font(.title)
                
                Spacer()
            }
        }
        .navigationTitle("Scanned Codes").navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isShowingScanner = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingScanner) {
            CodeScannerView(codeTypes: [.qr, .aztec, .catBody, .code128, .code39, .code39Mod43, .code93, .dataMatrix, .dogBody, .ean13, .ean8],
                            showViewfinder: true,
                            requiresPhotoOutput: true,
                            simulatedData: "This is a string of test String data.",
                            completion: viewModel.handleScan)
        }
        .onAppear {
            if startWithScanner {
                startWithScanner = false
                viewModel.isShowingScanner = true
            }
        }
    }
    
    @ViewBuilder
    private func qrScanRow(for qrscan: QRCodeData3) -> some View {
        NavigationLink {
            Text("Code Scan Details")
        } label: {
            createRow(qrscan: qrscan)
        }
        .swipeActions {
            Button("Delete", systemImage: "trash", role: .destructive) {
                if let index = viewModel.qrScans.firstIndex(where: { $0.id == qrscan.id }) {
                    viewModel.removeItem(index)
                }
            }
            
            if qrscan.isFavorite {
                Button("Remove favorite", systemImage: "star.slash") {
                    toggleFavorite(for: qrscan)
                }
                .tint(.gray)
            } else {
                Button("Add favorite", systemImage: "star.fill") {
                    toggleFavorite(for: qrscan)
                }
                .tint(.orange)
            }
        }
    }
    
    private func createRow(qrscan: QRCodeData3) -> some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(qrscan.qrCodeStringData)
                        .font(.headline)
                    Text(qrscan.dateAdded.formatted(date: .abbreviated, time: .shortened))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundStyle(qrscan.isFavorite ? .yellow : .clear)
                    .padding(.bottom, 10)
            }
        }
    }
    
    private func toggleFavorite(for qrscan: QRCodeData3) {
        if let index = viewModel.qrScans.firstIndex(where: { $0.id == qrscan.id }) {
            viewModel.qrScans[index].isFavorite.toggle()
        }
    }
}

#Preview {
    MainMenuButtons_View()
}

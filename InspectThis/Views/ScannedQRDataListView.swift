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
    @State private var viewModel = ScannedQRDataList_ViewModel()
    @State private var selectedRow = Set<QRCodeData2>()
    
    var body: some View {
        VStack {
            if !viewModel.qrScans.isEmpty {
                List(viewModel.qrScans, selection: $selectedRow) { qrscan in
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(qrscan.qrCodeStringData)
                                    .font(.headline)
                                
                                Text(qrscan.dateAdded.formatted(date: .abbreviated, time: .shortened))
                                    .foregroundStyle(.secondary)
                                
                                Text(qrscan.emailAddress)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            if qrscan.isFavorite {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(.yellow)
                                    .padding(.bottom, 10)
                            }
                        }

                    }
                    .swipeActions {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            if let index = viewModel.qrScans.firstIndex(where: { $0.id == qrscan.id }) {
                                viewModel.removeItem(index)
                            }
                        }
                        
                        // show the favorite / unFavorite mark
                        if qrscan.isFavorite {
                            Button("Remove favorite", systemImage: "star.slash") {
                                qrscan.isFavorite.toggle()
                            }
                            .tint(.orange)
                        } else {
                            Button("Mark as favorite", systemImage: "star.fill") {
                                qrscan.isFavorite.toggle()
                            }
                            .tint(.green)
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
                            simulatedData: "This is a string of test String data.",
                            completion: viewModel.handleScan)
        }
        
        
    }
}

#Preview {
    ContentView()
}

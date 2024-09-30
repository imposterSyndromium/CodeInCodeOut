//
//  ScannedQRDataListView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//  ¬∞



import CodeScanner
import SwiftUI

struct ScannedQRDataListView: View {
    @State var viewModel: QRData_ViewModel
    //@State private var selectedRow = Set<QRCodeData3>()
    @State var startWithScanner: Bool
    
    @State private var showQRImageView = false
    @State private var currentImageData: Data?
    
    private enum sortOrder: String, CaseIterable, Identifiable {
        case newestFirst = "Newest to oldest"
        case oldestFirst = "Oldest to newest"
        var id: String { self.rawValue }
    }
    @State private var sorting: sortOrder = .newestFirst {
        didSet {
            viewModel.sortNewestFirst = (sorting == .newestFirst)
        }
    }
    
    
    
    var body: some View {
        VStack {
            // Only show a list of scans if there are some
            if !viewModel.qrScans.isEmpty {
                List() {
                    
                    //only make a pined section if there are qrScans marked .isFavorite = true
                    if viewModel.qrScans.contains(where: { $0.isFavorite }) {
                        Section(header: Text("Pinned Codes")) {
                            ForEach(viewModel.qrScans.filter { $0.isFavorite }, id: \.id) { qrscan in
                                qrScanRow(for: qrscan)
                            }
                        }
                    }
                    
                    // the non-favorite / non-pinned list
                    Section(header: Text("Scanned Codes")) {
                        ForEach(viewModel.qrScans.filter { !$0.isFavorite }, id: \.id) { qrscan in
                            qrScanRow(for: qrscan)
                        }
                    }
                    
                }
                
            } else {
                
                VStack {
                    Button {
                        viewModel.isShowingScanner = true
                    } label: {
                        ContentUnavailableView("No scans yet!", systemImage: "qrcode.viewfinder", description: Text("There are no scanned codes yet.  Press to scan a code with your camera to start"))
                    }
                    .foregroundStyle(.gray)
                    
                }
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
            ToolbarItem(placement: .topBarLeading) {
                Menu(content: {
                    Picker("Sort Order", selection: $sorting) {
                        ForEach(sortOrder.allCases) { sort in
                            Text(sort.rawValue).tag(sort)
                        }
                    }
                    
                }, label: { Image(systemName: "barcode")})
            }
        }
        .sheet(isPresented: $viewModel.isShowingScanner) {
            CodeScannerCamera_View(viewModel: viewModel)
        }        
        .onAppear {
            if startWithScanner {
                startWithScanner = false
                viewModel.isShowingScanner = true
            }
        }
        .onChange(of: viewModel.qrScans) {
            // This will force the view to update when qrScans changes
            // You might not need this if you're using @Observable correctly
            viewModel.fetchItems()
        }
    }
    
    
    

    private func qrScanRow(for qrscan: QRCodeData3) -> some View {
        NavigationLink {
            //Text("Code Scan Details")
            DetailView(qrScan: qrscan)
            
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(qrscan.qrCodeStringData)
                            .font(.headline)
                        Text(qrscan.dateAdded.formatted(date: .abbreviated, time: .shortened))
                            .foregroundStyle(.secondary)
                    }
                    
                    if qrscan.isFavorite {
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .padding(.bottom, 10)
                    }
                }
            }
        }
        .swipeActions(edge: .trailing) {
            Button("Delete", systemImage: "trash", role: .destructive) {
                if let index = viewModel.qrScans.firstIndex(where: { $0.id == qrscan.id }) {
                    withAnimation {
                        viewModel.removeItem(index)
                    }
                }
            }
            
            
        }
        .swipeActions(edge: .leading) {
            if qrscan.isFavorite {
                Button("Remove favorite", systemImage: "star.slash") {
                    withAnimation {
                        toggleFavorite(for: qrscan)
                    }
                }
                .tint(.gray)
            } else {
                Button("Add favorite", systemImage: "star.fill") {
                    withAnimation {
                        toggleFavorite(for: qrscan)
                    }
                }
                .tint(.orange)
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
    MainTabView()
}

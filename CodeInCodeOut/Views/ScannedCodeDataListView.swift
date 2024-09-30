//
//  ScannedQRDataListView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//  ¬∞



import CodeScanner
import SwiftData
import SwiftUI

struct ScannedCodeDataListView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var codeScans: [CodeScanData]
    
    @State private var isShowingScanner: Bool = false
    
    @State private var showQRImageView = false
    @State private var currentImageData: Data?
    
    private enum sortOrder: String, CaseIterable, Identifiable {
        case newestFirst = "Newest to oldest"
        case oldestFirst = "Oldest to newest"
        var id: String { self.rawValue }
    }
    @State private var sorting: sortOrder = .newestFirst
//    {
//        didSet {
//            viewModel.sortNewestFirst = (sorting == .newestFirst)
//        }
//    }
    
    
    
    var body: some View {
        VStack {
            // Only show a list of scans if there are some
            if !codeScans.isEmpty {
                List() {
                    
                    //only make a pined section if there are qrScans marked .isFavorite = true
                    if codeScans.contains(where: { $0.isFavorite }) {
                        Section(header: Text("Pinned Codes")) {
                            ForEach(codeScans.filter { $0.isFavorite }, id: \.id) { codescan in
                                codeScanRow(for: codescan)
                            }
                        }
                    }
                    
                    // the non-favorite / non-pinned list
                    Section(header: Text("Scanned Codes")) {
                        ForEach(codeScans.filter { !$0.isFavorite }, id: \.id) { codescan in
                            codeScanRow(for: codescan)
                        }
                    }
                    
                }
                
            } else {
                
                VStack {
                    Button {
                        isShowingScanner = true
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
                    isShowingScanner = true
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
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerCamera_View()
        }        
    }
    
    
    

    private func codeScanRow(for codescan: CodeScanData) -> some View {
        NavigationLink {
            //Text("Code Scan Details")
            DetailView(codeScan: codescan)
            
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(codescan.codeStingData)
                            .font(.headline)
                        Text(codescan.dateAdded.formatted(date: .abbreviated, time: .shortened))
                            .foregroundStyle(.secondary)
                    }
                    
                    if codescan.isFavorite {
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
                withAnimation {
                    modelContext.delete(codescan)
                }
            }
        }
        .swipeActions(edge: .leading) {
            if codescan.isFavorite {
                Button("Remove favorite", systemImage: "star.slash") {
                    withAnimation {
                        toggleFavorite(for: codescan)
                    }
                }
                .tint(.gray)
            } else {
                Button("Add favorite", systemImage: "star.fill") {
                    withAnimation {
                        toggleFavorite(for: codescan)
                    }
                }
                .tint(.orange)
            }
        }
    }

    

    
    
    

    
    
    
    private func toggleFavorite(for codescan: CodeScanData) {
        codescan.isFavorite.toggle()
    }
    
    

}

#Preview {
    let preview = Preview()
    preview.addExampleData(CodeScanData.sampleScans)
    return ScannedCodeDataListView()
        .modelContainer(preview.container)
    
}

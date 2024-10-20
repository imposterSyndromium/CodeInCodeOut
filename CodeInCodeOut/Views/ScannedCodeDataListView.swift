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
    
    @State var isShowingScanner: Bool = false
    @State private var currentImageData: Data?
    @State private var sortingOrder = SortDescriptor(\CodeScanData.dateAdded, order: .reverse)
    @Binding var selectedTab: Int
    
    private var sortedCodeScans: [CodeScanData] {
        codeScans.sorted(using: sortingOrder)
    }
    
    private enum sortedBy: String, CaseIterable, Identifiable {
        case newestFirst = "Newest to oldest"
        case oldestFirst = "Oldest to newest"
        var id: String { self.rawValue }
    }
    @State private var sorting: sortedBy = .newestFirst
    
    
    
    var body: some View {
        VStack {
            if !codeScans.isEmpty {
                
                List {
                    // pinned codes: only show this section if we have pinned codes to show
                    if codeScans.contains(where: { $0.isFavorite }) {
                        Section(header: Text("Pinned Codes")) {
                            ForEach(sortedCodeScans.filter { $0.isFavorite }, id: \.id) { codescan in
                                codeScanRow(for: codescan)
                            }
                        }
                        .listRowBackground(Color.listRowColor)
                    }
                    
                    // non-pinned codes: only show this section if we have non-pinned codes to show
                    if codeScans.contains(where: { !$0.isFavorite }) {
                        Section(header: Text("Scanned Codes")) {
                            ForEach(sortedCodeScans.filter { !$0.isFavorite }, id: \.id) { codescan in
                                codeScanRow(for: codescan)
                            }
                        }
                        .listRowBackground(Color.listRowColor)
                    }
                }
                
            } else {
                ContentUnavailableView("No scans yet!", systemImage: "qrcode.viewfinder", description: Text("There are no scanned codes yet.  Scan a code with your camera to start"))
                    .foregroundStyle(.gray)
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
                        ForEach(sortedBy.allCases) { sort in
                            Text(sort.rawValue).tag(sort)
                        }
                    }
                }, label: { Image(systemName: "arrow.up.arrow.down") })
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerCameraView()
        }
        .onChange(of: sorting) { _, newValue in
            updateSortingOrder(newValue)
        }
    }
    
    
    
    private func updateSortingOrder(_ order: sortedBy) {
        switch order {
        case .newestFirst:
            sortingOrder = SortDescriptor(\CodeScanData.dateAdded, order: .reverse)
        case .oldestFirst:
            sortingOrder = SortDescriptor(\CodeScanData.dateAdded, order: .forward)
        }
    }
    
    
    
    private func codeScanRow(for codescan: CodeScanData) -> some View {
        NavigationLink {
            DetailView(codeScan: codescan, selectedTab: $selectedTab)
            
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
                withAnimation(.easeOut) {
                    modelContext.delete(codescan)
                }
            }
        }
        .swipeActions(edge: .leading) {
            if codescan.isFavorite {
                Button("Remove favorite", systemImage: "star.slash") {
                    withAnimation(.spring) {
                        codescan.isFavorite.toggle()
                    }
                }
                .tint(.gray)
            } else {
                Button("Add favorite", systemImage: "star.fill") {
                    withAnimation(.spring) {
                        codescan.isFavorite.toggle()
                    }
                }
                .tint(.orange)
            }
        }
    }
    
    
    
}



//#Preview {
//    let preview = Preview()
//    preview.addExampleData(CodeScanData.sampleScans)
//    return MainTabView()
//        .modelContainer(preview.container)
//    
//}

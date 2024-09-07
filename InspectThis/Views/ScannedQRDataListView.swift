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
    

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.qrScans) { qrscan in
                    Text(qrscan.timeStamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                }
                .onDelete(perform: { offsets in
                    for index in offsets {
                        viewModel.removeItem(index)
                    }
                })
            }
        }
        .navigationTitle("QR Code Scanner")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.appendItem()
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isShowingScanner = true
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                }
                
            }
        }
        .sheet(isPresented: $viewModel.isShowingScanner) {
            CodeScannerView(codeTypes: [.qr],
                            simulatedData: "This is a string of test String data.",
                            completion: viewModel.handleScan)
            
        }
    }
    
    

}

#Preview {
    //ScannedQRDataListView( )
    ContentView()
}

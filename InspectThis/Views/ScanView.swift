//
//  HelloView.swift
//  InspectThis
//
//  Created by Robin O'Brien on 2024-09-05.
//
import CodeScanner
import SwiftUI

struct ScanView: View {
    
    @State var isShowingScanner = false
    
    var body: some View {
        VStack {
            Button {
                isShowingScanner = true
            } label: {
                VStack {
                    Text("Scan QR")
                        .font(.largeTitle)
                    Image(systemName: "qrcode")
                        .font(.system(size: 50))
                }
            }
        }
        .navigationTitle("QR Code Scanner")
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
    ContentView()
}
